#!/bin/sh -x

# Google Chrome Installer/Uninstaller for CentOS 6
# (C) Richard K. Lloyd 2013 <rklloyd@gmail.com>
# See http://chrome.richardlloyd.org.uk/ for further details.

# This script is in the public domain and has no warranty.
# It needs to be run as root because it installs/uninstalls RPMs.

# Minimum system requirements:
# - 32-bit or 64-bit CentOS 6.4 or later (you will be asked to
#   upgrade the OS and reboot if you're running 6.3 or earlier)
# - At least 250MB free in each of the temporary directory, /opt and /root
# - A working yum system (including http proxy configured if needed)
# - http_proxy env var set if you are using an http proxy
# - Google Chrome should not be running at the same time as this script

show_syntax()
# Show syntax of script
{
   cat <<@EOF
Syntax: ./install_chrome.sh [-b] [-d] [-h] [-n] [-q] [-s] [-t tmpdir] [-u] [-U]

-b (or --beta) will switch to beta versions (google-chrome-beta).
-d (or --delete) will delete the temporary directory used for downloads
   if an installation was successful.
-h (or -? or --help) will display this syntax message.
-n (or --dryrun) will show what actions the script will take,
   but it won't actually perform those actions.
-q (or --quiet) will switch to "quiet mode" where minimal info is displayed.
   Specify -q twice to go completely silent except for errors.
-s (or --stable) will switch to stable versions (google-chrome-stable),
   which is the default if -b or -U haven't previously been specified.
-t tmpdir (or --tmpdir tmpdir) will use tmpdir as the temporary directory
   parent tree rather than \$TMPDIR (if set) or /tmp.
-u performs an uninstallation of Google Chrome and chrome-deps rather the
   default action of an installation.
-U (or --unstable) will switch to unstable versions (google-chrome-unstable).
@EOF
}

# Current version of this script
version="4.50"

# This script will download/install the following for an installation:

# These RPMs and their (many!) dependencies that aren't already installed:
# redhat-lsb, wget, xdg-utils, GConf2, libXSCrnSaver, libX11 (1.5+),
# gcc, glibc-devel, rpm-build and rpmdevtools.
# The latest Google Chrome RPM if not already downloaded (or out-of-date).
# 5 RPM packages from Fedora 15 if not already fully downloaded.

# It then copies 10 libraries from the F15 packages into /opt/google/chrome/lib.
# It also changes ld library references in four F15 libraries to end
# in .so.0 instead of .so.2 so that they avoid the system ld library.
# It sets SELinux context user/type for the F15 libraries as well if SELinux
# is enabled on the system.

# Next, it C-compiles an LD_PRELOAD library that's installed as
# /opt/google/chrome/lib/unset_var.so, which saves/unsets LD_LIBRARY_PATH
# and LD_PRELOAD before calling exec*() routines and then restores the
# environmental variables afterwards.
# /opt/google/chrome/google-chrome is also modified to point LD_PRELOAD
# to the installed library. This is avoids having LD_LIBRARY_PATH and
# LD_PRELOAD set when sub-processes are run.

# Finally, it creates and installs a chrome-deps RPM which includes the
# F15 libraries, unset_var.so and code to modify the google-chrome wrapper.

# Note that you can't run Google Chrome as root - it stops you from doing so.

# Revision history:

# 4.50 - 11th December 2013
# - A user reported that file-roller wouldn't work when opening downloaded
#   .tar.gz files inside Google Chrome. It turns out LD_PRELOAD was still set
#   when file-roller tried to exec() sub-processes like gzip, so I now unset
#   LD_PRELOAD (as well as LD_LIBRARY_PATH) when exec'ing from within Google
#   Chrome, which fixes the issue. chrome-deps version was bumped to 1.10
#   because of this change. Another user suggested checking previously downloaded
#   F15 RPMs have the right checksum/size (and a fresh download is forced if
#   they don't), which has been implemented.

# 4.41 - 9th December 2013
# - Added glibc-devel to the list of dependencies because a user reported
#   that it wasn't dragged in by gcc. With the imminent release of Fedora 20,
#   Fedora 15 has been archived and the code has been changed to reflect that.
#   Removed SELinux warning at end of install - the last few releases of
#   Google Chrome don't seem to have a problem with enforcing mode w.r.t.
#   nacl_helper. Future releases of this script may remove all SELinux-related
#   code if enforcing mode remains OK. Google Chrome 31 is displaying a
#   manifestTypes error to the console in some setups, but this doesn't seem
#   to affect the running of Google Chrome.

# 4.40 - 5th October 2013
# - A similar issue to the 4.30 release cropped up again (reported by
#   the same user!) that I still can't reproduce. This time it was a missing
#   gdk_pixbuf_format_get_type symbol in F15's libgtk-x11-2.0. This was fixed
#   by additonally downloading F15's gdk-pixbuf2 RPM and extracting
#   libgdk_pixbuf-2.0 from it. This prompted a bump of the chrome-deps RPM to
#   version 1.03.

# 4.30 - 4th October 2013
# - The g_desktop_app_info_get_filename symbol in the F15 libgdk-x11-2.0
#   library is present in the F15 libgio-2.0 library (but not in CentOS's).
#   The script used the former library, but not the latter and a user reported
#   a missing symbol crash due to this, despite my testing not showing the
#   issue. This release is therefore purely to add libgio-2.0 and its
#   libgobject-2.0 dependency to the set of extracted F15 libraries and has
#   also been tested against Google Chrome 30 and Google Talk Plugin 4.7.0.0.
#   The chrome-deps RPM is now at version 1.02 because of the two extra
#   libraries.

# 4.20 - 22nd August 2013
# - If the Google Chrome repo is enabled and a Google Chrome RPM is already
#   installed, use "yum check-update google-chrome-stable" to determine if
#   there is a newer version available and then fallback to using the
#   OmahaProxy site if there isn't.
# - Any newer version than what's been previously downloaded or installed
#   can now be downloaded/installed, rather than being exactly the version
#   displayed on the OmahaProxy site (which was out of date for a full day when
#   Chrome 29 was released, stopping this script from updating to version 29).
# - Removed terminal messages warning because this is fixed with Google Chrome
#   29.
# - Used extra parameters in the OmahaProxy request to narrow the data down to
#   the exact channel and platform (linux).

# 4.10 - 8th August 2013
# - Fixed Google Talk (Hangouts) plugin crash - it was because, unlike Google
#   Chrome itself, the plugin hasn't been built with later libraries, so it
#   needs LD_LIBRARY_PATH to be unset. There still appears to be other
#   library issues with the Hangouts plugin, mainly because the older libraries
#   don't implement certain calls it uses. Google need to update the plugin!
#   Bumped chrome-deps version to 1.01 because of the unset_var.c change.
# - Catered for non-standard i686 RPM build trees on 32-bit systems. I couldn't
#   reproduce this myself (it uses i386 for me all the time in CentOS and
#   Scientific Linux 32-bit VMs) but the code is in place anyway for the users
#   that reported the issue.
# - modify_wrapper (now bumped to version 1.01) no longer echoes anything to
#   stdout after a successful update of /opt/google/chrome/google-chrome.

# 4.01 - 30th July 2013
# - Emergency 2-char change fix due to a terrible spec parsing bug in rpmbuild.
#   It appears that it tries to parse % directives in comment lines.
#   Strangely, three different build envs of mine didn't have the bug, but
#   a fourth one I tried did.
# 
# 4.00 - 30th July 2013
# - Creates a new chrome-deps RPM that it installs alongside the
#   google-chrome-stable RPM. It contains the Fedora libraries, the
#   built unset_var.so library and a script which is run post-install
#   to add code to /etc/default/google-chrome to modify google-chrome if
#   its LD_PRELOAD addition isn't present. This gets sourced daily by
#   /etc/cron.daily/google-chrome and is a way to auto-modify google-chrome
#   within a day of a Google Chrome update (this is because google-chrome
#   isn't marked as a config file by Google Chrome's spec file, so updates
#   will overwrite any changes made to it). The new code will also enable the
#   Google Chrome repo of course. Many thanks to Marcus Sandberg
#   for his spec file at https://github.com/adamel/chrome-deps which
#   I used as the initial basis for the spec file I create.
# - Adjusted unset_var code to not unset LD_LIBRARY_PATH if a full file
#   path (i.e. one containing a slash) is supplied to exec*() routines.
# - Download/installation of google-chrome-stable/chrome-deps dependencies
#   is now prompted for (if you decline, the script aborts).
# - Moved out-of-date OS check right to the end of the script and it also
#   now offers to reboot the machine after a successful OS update. Warn user
#   not to run Google Chrome if either the OS update or reboot are declined
#   until they complete the OS update and reboot.
# - Don't remove /etc/cron.daily/google-chrome or
#   /etc/yum.conf.d/google-chrome.repo any more because we actually want
#   people to use those (they won't be happy cron'ing this script or having
#   to regularly run it manually to check for updates).
# - Added -t option to specify the temporary directory parent tree.
# - Added -s (stable), -b (beta) and -U (unstable) options to switch
#   release channels. Yes, it remembers the switch, so you only have to
#   specify once time.
# - Added libdl.so.2 to the Fedora library list (for unset_var.so).

# 3.20 - 27th July 2013
# - Initial attempt to stop helper apps crashing by wrapping exec*() routines
#   with LD_PRELOAD functions that save/blank LD_LIBRARY_PATH, call the
#   original routines and, if they return, restore LD_LIBRARY_PATH. Seems to
#   stop crashes previously logged to syslog on startup at least, but does
#   require gcc and its dependencies to be installed now of course.

# 3.11 - 25th July 2013
# - If SELinux is enabled, set appropriate SELinux contexts on Fedora libraries
#   in /opt/google/chrome/lib and that directory itself. Investigation shows
#   that if you enable SELinux and set it to enforcing, nacl_helper appears to
#   fail to start correctly, possibly disabling sandboxing. The script warns
#   about this and suggests a temporary workaround of setting
#   SELINUX=permissive in /etc/selinux/config and rebooting. It's hoped to fix
#   this SELinux issue more permanently in a future release soon (any help is
#   most welcome!).

# 3.10 - 24th July 2013
# - Use .so.0 extension (instead of .so.3) for renamed Fedora ld-linux library
#   and change ld-linux*.so.2 references to ld-linux*.so.0 in ld-linux, libc
#   and libstdc++. Thanks to Marcus Sundberg for this suggestion.
# - Dependency list for Google Chrome RPM is now redhat-lsb, wget, xdg-utils,
#   GConf2, libXSCrnSaver and libX11 (not 1.3* or 1.4* though).
# - If OS version ("lsb_release -rs") is less than 6.4 then
#   offer to "yum update" and refuse to continue if the user declines.
#   If you don't update to at least 6.4, bad things can
#   happen (I got a hang and a memory allocation error when starting Google
#   Chrome on a CentOS 6.0 VM for example).

# 3.00 - 21st July 2013
# - Command-line options now supported including -d (delete temp dir),
#   -h (syntax help), -n (dry run), -q (quiet) and -u (uninstall).
# - Abort if Google Chrome is running when the script is started.
# - Display any non-zero disk space figures for /opt/google/chrome and the
#   temporary download directory at the start and end of the script.

# 2.10 - 20th July 2013
# - Can now detect if Fedora 15 RPMs have been archived and will download
#   them from the archive site if they're found there instead.
# - Fixed lsb package check, so lsb deps will actually be downloaded now.
# - Follow Fedora 15 library soft-links to determine the actual filenames
#   that need to be copied.
# - Removed /etc/cron.daily/google-chrome and
#   /etc/yum.repos.d/google-chrome.repo straight after the Google Chrome RPM
#   is installed to avoid any potential conflict with old releases.
# - Simplistic check for RHEL 6 derivatives (initially a prompt if the
#   script thinks you aren't running one, but a future release will block
#   non-derivatives).
# - Early exits due to errors or an interrupt (CTRL-C) will now properly
#   tidy up files in the temporary directory and uninstall the Google Chrome
#   RPM if it was installed.
# - All downloads now go via a common function, which saves any pre-existing
#   file as a .old version and renames it back if the download fails.

# 2.00 - 14th July 2013
# - Installed a 32-bit CentOS 6.4 VM and this enabled me to add initial 32-bit
#   support, though there is an nacl_helper issue that I display a warning for.
#   Thanks to Seva Epsteyn for a 32-bit patch that got the ball rolling.
# - Check for version number of latest Google Chrome and download/install it
#   if it hasn't been already.
# - Use updated Fedora 15 RPMs rather than the original ISO versions.
# - Warn if an enabled Google Chrome repo is detected (we don't want it).
# - Tidied main code into separate functions.
# - Added blank lines before/after messages and prefixed them with three stars.
# - Displayed more messages now they're easier to read.

# 1.10 - 13th July 2013
# - Added an update check for a new version of this script.
#   It will always download/install the new version, but will ask
#   if you want to run the new version or exit in case you want to
#   code inspect it first.
# - Always force-install a downloaded Google RPM, even if a version
#   is already installed. Yes, very obvious it should do this but it
#   didn't (slaps forehead).

# 1.02 - 13th July 2013
# - Second emergency fix today as someone spotted that wget needed
#   "--no-check-certificate" to talk to Google's https download site.
#   I didn't need it for the two machines I tested it on though!
# - Added in a check for wget as well while I was at it and it will
#   yum install wget if it's not found.

# 1.01 - 13th July 2013
# - Bad variable fix if you've not downloaded Google Chrome's RPM yet.
#   Serves me right for making a last minute change and not testing it :-(

# 1.00 - 13th July 2013
# - Tested on 64-bit CentOS 6.4 using Fedora 15 libraries. Code is there
#   for 32-bit but has not been tested at all because I have no such systems.

message_blank_line()
# $1 != "n" (and no quiet mode) to display blank line
{
   if [ $quiet -eq 0 -a "$1" != "n" ]
   then
      echo
   fi
}

message_output()
# Display $1 depending on the quiet mode
{
   case "$quiet" in
   0) echo "*** $1 ..." ;;
   1) echo "$1" ;;
   esac
}

message()
# Display a message (passed in $1) prominently
# $2 = "n" to avoid displaying blank lines before or after the message
{
   if [ $quiet -eq 2 ]
   then
      return
   fi

   if [ $dry_run -eq 1 ]
   then
      echo "Would display the following message:"
      message_output "$1"
      echo
      return
   fi

   message_blank_line "$2"
   message_output "$1"
   message_blank_line "$2"
}

warning()
# $1 = Warning message to display to stderr
# $2 = "n" to avoid displaying blank lines before or after the message
{
   message "WARNING: $1" "$2" >&2
}

show_space_used()
# Calculate disk space and number of files in install and temp dirs
# and display it if there actually any installed files
{
   for each_tree in "$inst_tree" "$tmp_tree"
   do
      if [ -d "$each_tree" ]
      then
         num_files="`find \"$each_tree/.\" -type f | wc -l`"
         if [ $num_files -gt 0 ]
         then
            size_files="`du -s \"$each_tree/.\" | awk '{ printf(\"%d\",$1/1024); }'`"
            message "$each_tree tree contains $num_files files totalling $size_files MB" "n"
         fi
      fi
   done 
}

clean_up()
# Remove the stuff we don't want to keep once script finishes
{
   # Make sure we don't trash system directories!
   if [ "$tmp_tree" != "" -a "$tmp_tree" != "/" -a "$tmp_tree" != "/tmp" ]
   then
      if [ $delete_tmp -eq 1 ]
      then
         if [ -d "$tmp_tree" ]
         then
            if [ $dry_run -eq 1 ]
            then
               echo "Would delete temporary dir $tmp_tree"
               echo
            else
               cd /
               rm -rf "$tmp_tree"
               if [ -d "$tmp_tree" ]
               then
                  warning "Failed to delete temporary directory $tmp_tree"
               else
                  message "Deleted temporary directory $tmp_tree"
               fi
            fi
         fi
      else
         rm_dir_list="etc lib lib64 usr sbin usr var"
         if [ $dry_run -eq 1 ]
         then
            echo "Would delete these directories from inside of $tmp_tree:"
            echo "$rm_dir_list"
         else
            # We delete specific directories so that RPM downloads/builds
            # remain and can be re-used if the script is run again
            for each_dir in $rm_dir_list
            do
               rm -rf "$tmp_tree/$each_dir"
            done
         fi
      fi

      show_space_used
   fi
}

is_installed()
# See if $1 package is installed (returns non-null string if it is)
{
   rpm -q "$1" | egrep "($rpmarch|$arch|noarch)" | grep "^$1"
}

uninstall_rpms()
# Uninstall $* RPMs if they are installed
{
   uninstall_list=""
   for each_pack in $*
   do
      if [ "`is_installed $each_pack`" != "" ]
      then
         uninstall_list="$uninstall_list $each_pack"
      fi
   done

   if [ "$uninstall_list" != "" ]
   then
      if [ $dry_run -eq 1 ]
      then
         echo "Would uninstall $uninstall_list using \"yum remove\""
         echo
      else
         message "Uninstalling $uninstall_list"
         yum $yum_options remove $uninstall_list
      fi
   fi
}

uninstall_google_chrome()
# Uninstall the Google Chrome and chrome-deps RPMs if they are installed
{
   uninstall_rpms $rpm_name $deps_name

   # Do a final cleanup if /opt/google/chrome persists
   if [ "$inst_tree" != "" -a "$inst_tree" != "/" -a "$inst_tree" != "/tmp" ]
   then
      if [ -d "$inst_tree" -a $dry_run -eq 0 ]
      then
         warning "$inst_tree install tree still present - deleting it" "n"
         cd /
         rm -rf "$inst_tree"
         if [ -d "$inst_tree" ]
         then
            warning "Failed to delete $inst_tree install tree" "n"
         fi
      fi
   fi
}

error()
# $1 = Error message
# Exit script after displaying error message
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would display this error message to stderr:"
      echo "ERROR: $1 - aborted"
   else
      echo >&2
      echo "ERROR: $1 - aborted" >&2
      echo >&2
   fi

   # A failure means we have to uninstall Google Chrome
   # if it got on the system and we were installing, but only
   # if we got past the check that it was running
   if [ $do_install -eq 1 -a $past_run_check -eq 1 ]
   then
      uninstall_google_chrome
   fi

   clean_up

   exit 1
}

interrupt()
# Interrupt received (usually CTRL-C)
{
   error "Interrupt (usually CTRL-C) received"
}

set_tmp_tree()
# Set tmp_tree variable to $1/chrome_install
{
   if [ "$1" = "" -o "$1" = "/" -o "`echo \"x$1\" | grep ^x-`" != "" ]
   then
      error "Invalid temporary directory parent specified ($1)"
   fi

   if [ ! -d "$1" ]
   then
      warning "Temporary directory parent $1 doesn't exist - will be created"
   fi

   tmp_tree="$1/chrome_install"
   unsetsrc="$tmp_tree/unset_var.c"
}

check_binary_not_running()
# See if the Google Chrome binary is running and abort if it is
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would check to see if $chrome_name is running and abort if it is."
      echo
   else
      if [ "`ps -ef | grep \"$inst_tree/chrome\" | grep -v grep`" != "" ]
      then
         error "$chrome_name is running - exit it then re-run this script"
      fi
   fi
   past_run_check=1
}

set_rpm_type()
# Set RPM type to $1
# $1 = stable, beta or unstable
{
   if [ $do_install -eq 1 -a "$1" != "$old_rpm_type" ]
   then
      case "$1" in
      stable|beta|unstable)
         if [ $dry_run -eq 1 ]
         then
            echo "Would prompt to confirm switch to $1 channel"
            echo "(assuming y is input)"
            echo
         else
            warning "You have requested to switch to the $1 channel"
            if [ $quiet -eq 0 ]
            then
               echo "This script will uninstall all previously installed $chrome_name"
               echo "packages that originated from non-$1 channels."
               echo
            fi
            yesno "install the $1 release (and uninstall all non-$1s)"
            if [ $ans -eq 0 ]
            then
               error "Did not switch to the $1 channel"
            fi
         fi ;;
      *) error "Invalid $chrome_name channel ($1)" ;;
      esac

      check_binary_not_running
      uninstall_rpms \
      `echo google-chrome-stable google-chrome-beta google-chrome-unstable | \
       sed -e "s/google-chrome-$1//g"`
   fi
   
   case "$1" in
   stable|beta|unstable)
     rpm_type="$1"
     case "$1" in
     unstable) csv_type="dev" ;;
            *) csv_type="$1" ;;
     esac
     rpm_name="google-chrome-$1"
     chrome_csv="http://omahaproxy.appspot.com/all?os=linux&channel=$csv_type"
     chrome_rpm="${rpm_name}_current_$rpmarch.rpm" ;;
   *) error "Invalid $chrome_name type ($1)" ;;
   esac
}

init_vars()
# Initialise variables
# $1 = Original $0 (i.e. script name)
{
   # Set option variables to temporary values so that errors prior to the
   # actual option parsing behave sensibly
   dry_run=0 ; do_install=0 ; delete_tmp=0 
   past_run_check=0

   # Avoid picking up the Fedora libs for any binaries
   # run by this script
   unset LD_LIBRARY_PATH

   if [ "$TMPDIR" = "" ]
   then
      set_tmp_tree "/tmp"
   else
      set_tmp_tree "$TMPDIR"
   fi

   arch="`uname -m`"
   case "$arch" in
   x86_64) rellib="lib64" ; ld_linux="ld-linux-x86-64" ; rpmarch="$arch" ;;
     i686) rellib="lib" ; ld_linux="ld-linux" ; rpmarch="i386" ;;
        *) error "Unsupported architecture ($arch)" ;;
   esac
   relusrlib="usr/$rellib"

   chrome_name="Google Chrome"
   chrome_defaults="/etc/default/google-chrome"
   chrome_repo="/etc/yum.conf.d/google-chrome.repo"

   # Find the most stable installed Google Chrome and use that
   # as the default for the rest of the script (override with -b, -s or -U)
   old_rpm_type=""
   for each_old_rpm_type in stable beta unstable
   do
      if [ "$old_rpm_type" = "" ]
      then
         if [ "`is_installed google-chrome-$each_old_rpm_type`" != "" ]
         then
            old_rpm_type="$each_old_rpm_type"
         fi
      fi
   done

   # If nothing installed at all, default to stable
   if [ "$old_rpm_type" = "" ]
   then
      old_rpm_type="stable"
   fi
   set_rpm_type "$old_rpm_type"

   inst_tree="/opt/google/chrome"
   libdir="$inst_tree/lib"
   chrome_wrapper="$inst_tree/google-chrome"
   modify_wrapper="$inst_tree/modify_wrapper"

   deps_name="chrome-deps"
   deps_version="1.10"
   deps_latest="`is_installed $deps_name | grep $deps_version`"
   wrapper_mod_version="1.01"
   install_success=0
   trap "interrupt" 1 2 3

   fedver=15 # Fedora version with needed libraries (F16 doesn't work!)
   suffix="$arch.rpm"
   # $fedver archived updated packages URL
   baseurl="http://archives.fedoraproject.org/pub/archive/fedora/linux/updates/$fedver/$rpmarch"
   wget="/usr/bin/wget"
   wget_options="--no-check-certificate"
   yum_options="-y"
   rpm_options="-U --force --nodeps"
   chcon_options="-u system_u"
   rpmbuild_options="-bb"
   new_ld_suff=."so.0"

   # Update checker URL
   checksite="http://chrome.richardlloyd.org.uk/"
   checkfile="version.dat"
   checkurl="$checksite$checkfile"
   scriptname="install_chrome.sh"
   upgradeurl="$checksite$scriptname"

   unsetlib="$libdir/unset_var.so"

   script="$1"
   case "$script" in
    ./*) script="`pwd`/`basename $script`" ;;
     /*) script="$script" ;;
      *) script="`pwd`/$script" ;;
   esac
}

download_file()
# $1 = Full URL to download
# $2 = Optional basename to save to (if omitted, then = basename $1)
#      Also allow download to fail without exit if $2 is set
{
   if [ "$2" = "" ]
   then
      dlbase="`basename \"$1\"`"
   else
      dlbase="$2"
   fi

   if [ $dry_run -eq 1 ]
   then
      echo "Would download this URL to $tmp_tree/$dlbase :"
      echo $1 ; echo
      return
   fi

   old_dlbase="$dlbase.old"
   if [ -f "$dlbase" ]
   then
      rm -f "$old_dlbase"
      mv -f "$dlbase" "$old_dlbase"
   fi

   message "Downloading $dlbase (please wait)"
   $wget $wget_options -O "$dlbase" "$1"

   if [ ! -s "$dlbase" ]
   then
      if [ -f "$old_dlbase" ]
      then
         mv -f "$old_dlbase" "$dlbase"
      fi
      if [ "$2" = "" ]
      then
         error "Failed to download $dlbase"
      fi
   fi
}

change_se_context()
# $1 = File or directory name
# Change SELinux context type for $1 to lib_t (or other
# types depending on its name)
{
   if [ $selinux_enabled -eq 0 ]
   then
      # chcon commands fail if SELinux is disabled
      return
   fi

   if [ -s "$1" -o -d "$1" ]
   then
      case "$1" in
          *$ld_linux*) con_type="ld_so_t" ;;
      $chrome_wrapper) con_type="execmem_exec_t" ;;
            $unsetlib) con_type="textrel_shlib_t" ;;
                    *) con_type="lib_t" ;;
      esac

      if [ $dry_run -eq 1 ]
      then
         echo "Would change SELinux context type of $1 to $con_type"
         echo
      else
         chcon $chcon_options -t $con_type "$1"
      fi
   else
      if [ $dry_run -eq 0 ]
      then
         error "Couldn't change SELinux context type of $1 - not found"
      fi
   fi
}

install_ld_preload_lib()
# Compile and install LD_PRELOAD lib as $libdir/unset_var.so
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would compile/install $unsetlib and"
      echo "add LD_PRELOAD=$unsetlib to $chrome_wrapper"
      echo
      return
   fi
     
   cat <<@EOF >"$unsetsrc"
/* unset_var.c 1.10 (C) Richard K. Lloyd 2013 <rklloyd@gmail.com>

   LD_PRELOAD code to save LD_LIBRARY_PATH, blank LD_LIBRARY_PATH
   if the file to be exec'd isn't a full path, unset LD_PRELOAD,
   run the original exec*() library routine and then restore
   LD_LIBRARY_PATH and LD_PRELOAD.
  
   This way, we can avoid Fedora 15 libraries being picked up
   by helper apps or plugins that are subsequently loaded by
   Google Chrome.

   strings -a /opt/google/chrome/chrome | grep ^exec
   reveals three exec* routines used by the binary:
   execvp(), execve() and execlp().

   Compile with:
   gcc -O -fpic -shared -s -o unset_var.so unset_var.c -ldl

   Run with:
   export LD_PRELOAD=/path/to/unset_var.so
   /opt/google/chrome/google-chrome
*/

/* Have to build with this flag defined */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

/* The environmental variables we're going to unsetenv() */
#define PATH_ENV_VAR "LD_LIBRARY_PATH"
#define PRELOAD_ENV_VAR "LD_PRELOAD"

/* Some system headers */
#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <stdarg.h>
#include <string.h>

/* Each routine we intercept is likely to have different parameter types
   and return types too, so firstly, we create common code macros */

/* Define local variables for function, passing in the function return type */
#define INTERCEPT_LOCAL_VARS(return_type) \
   char *pathenvptr=getenv(PATH_ENV_VAR), \
        *preloadenvptr=getenv(PRELOAD_ENV_VAR); \
   static char pathsavebuf[BUFSIZ],preloadsavebuf[BUFSIZ]; \
   /* FILE *outhand=fopen("/tmp/exec.log","a"); */ \
   return_type retval

/* Save PATH_ENV_VAR and PRELOAD_ENV_VAR values in local buffers and then
   unset the former if it's not a full path or is a Google Talk plugin path
   and always unset the latter */
#define INTERCEPT_SAVE_VAR(fname) \
   if (pathenvptr!=(char *)NULL && pathenvptr[0]!='\0') \
      (void)snprintf(pathsavebuf,BUFSIZ,PATH_ENV_VAR "=%s",pathenvptr); \
   else pathsavebuf[0]='\0'; \
   if (preloadenvptr!=(char *)NULL && preloadenvptr[0]!='\0') \
      (void)snprintf(preloadsavebuf,BUFSIZ,PRELOAD_ENV_VAR "=%s",preloadenvptr); \
   else preloadsavebuf[0]='\0'; \
   /* if (outhand!=(FILE *)NULL) { fprintf(outhand,"%s\n",fname); (void)fclose(outhand); } */ \
   if (strstr(fname,"/")==(char *)NULL || \
       strstr(fname,"/opt/google/talkplugin/")!=(char *)NULL) unsetenv(PATH_ENV_VAR); \
   unsetenv(PRELOAD_ENV_VAR)

/* Restore PATH_ENV_VAR and PRELOAD_ENV_VAR values if they had any previously
   and then return the value from the function. */
#define INTERCEPT_RESTORE_VAR \
   if (pathsavebuf[0]) putenv(pathsavebuf); else unsetenv(PATH_ENV_VAR); \
   if (preloadsavebuf[0]) putenv(preloadsavebuf); else unsetenv(PRELOAD_ENV_VAR); \
   return(retval)

/* Now string it into macros for different numbers of parameters. */

/* execvp() */
#define INTERCEPT_2_PARAMS(return_type,function_name,function_name_str,param_1_type,param_1_name,param_2_type,param_2_name) \
return_type function_name(param_1_type param_1_name,param_2_type param_2_name) \
{ \
   INTERCEPT_LOCAL_VARS(return_type); \
   return_type (*original_##function_name)(param_1_type,param_2_type); \
   original_##function_name=dlsym(RTLD_NEXT,function_name_str); \
   INTERCEPT_SAVE_VAR(param_1_name); \
   retval=(*original_##function_name)(param_1_name,param_2_name); \
   INTERCEPT_RESTORE_VAR; \
}

/* execve() */
#define INTERCEPT_3_PARAMS(return_type,function_name,function_name_str,param_1_type,param_1_name,param_2_type,param_2_name,param_3_type,param_3_name) \
return_type function_name(param_1_type param_1_name,param_2_type param_2_name,param_3_type param_3_name) \
{ \
   INTERCEPT_LOCAL_VARS(return_type); \
   return_type (*original_##function_name)(param_1_type,param_2_type,param_3_type); \
   original_##function_name=dlsym(RTLD_NEXT,function_name_str); \
   INTERCEPT_SAVE_VAR(param_1_name); \
   retval=(*original_##function_name)(param_1_name,param_2_name,param_3_name); \
   INTERCEPT_RESTORE_VAR; \
}

/* execlp() - I'm not fully sure I've done the va_list stuff right here! */
#define INTERCEPT_2_VARARGS(return_type,function_name,function_name_str,param_1_type,param_1_name,param_2_type,param_2_name) \
return_type function_name(param_1_type param_1_name,param_2_type param_2_name,...) \
{ \
   va_list args; \
   INTERCEPT_LOCAL_VARS(return_type); \
   return_type (*original_##function_name)(param_1_type,param_2_type,...); \
   original_##function_name=dlsym(RTLD_NEXT,function_name_str); \
   INTERCEPT_SAVE_VAR(param_1_name); \
   va_start(args,param_2_name); \
   retval=(*original_##function_name)(param_1_name,param_2_name,args); \
   va_end(args); \
   INTERCEPT_RESTORE_VAR; \
}

/* Only 3 routines intercepted so far - may be more in the future */
INTERCEPT_2_PARAMS(int,execvp,"execvp",const char *,file,const char **,argv);
INTERCEPT_3_PARAMS(int,execve,"execve",const char *,filename,const char **,argv,const char **,envp);
INTERCEPT_2_VARARGS(int,execlp,"execlp",const char *,file,const char *,arg);
@EOF

   if [ -s "$unsetsrc" ]
   then
      gcc -O -fpic -shared -s -o "$unsetlib" "$unsetsrc" -ldl
      rm -f "$unsetsrc"
      if [ -s "$unsetlib" ]
      then
         chmod a+rx "$unsetlib"
         change_se_context "$unsetlib"
         message "Compiled/installed $unsetlib"
      else
         error "Failed to compile/install $unsetlib"
      fi
   else
      error "Unable to create $unsetsrc source file"
   fi
}

install_library()
# $1 = Core of basename of RPM filename
# $2 = cksum of 64-bit RPM
# $3 = Size of 64-bit RPM (in bytes)
# $4 = cksum of 32-bit RPM
# $5 = Size of 32-bit RPM (in bytes)
# $6 = After unpacking, relative path to library soft-link
# $7 = Optional rename filename
{
   if [ "$7" = "" ]
   then
      lib_name="`basename $6`"
   else
      lib_name="$7"
   fi
   fname="$libdir/$lib_name"
   nonorig="$libdir/`basename $lib_name .orig`"

   if [ "$fname" != "$nonorig" ]
   then
      # We hit here if library is patchable -
      # we must leave function with the .orig file existing
      if [ -s "$nonorig" -a ! -s "$fname" ]
      then
         # We have the non-.orig file and don't have the .orig one,
         # rename one to the other. It will get patched later on.
         mv -f "$nonorig" "$fname"
      fi
   fi

   # Obvious optimisation here - if Fedora library is already installed,
   # we only change SELinux context (no RPM or extraction needed)
   # as long as patching isn't needed (the patching changed in 3.10+
   # so we can't be sure the patch has been applied).
   if [ -s "$fname" -a "$7" = "" ]
   then
      change_se_context "$fname"
      return
   fi

   rpmfile="$1.$suffix"
   case "$arch" in
   x86_64) rpmcksum="$2 $3 $rpmfile" ;;
        *) rpmcksum="$4 $5 $rpmfile" ;;
   esac

   if [ -s $rpmfile ]
   then
      if [ "`cksum $rpmfile`" != "$rpmcksum" ]
      then
         rm -f $rpmfile
         warning "Deleted pre-existing $rpmfile - checksum or size incorrect"
      fi
   fi

   if [ ! -s $rpmfile ]
   then
      download_file "$baseurl/$rpmfile"
   fi

   message "Installing $fname" "n"

   if [ $dry_run -eq 1 ]
   then
      echo "Would unpack $rpmfile using rpm2cpio/cpio and"
      echo "then copy $6 to $fname" ; echo
      return
   fi

   rpm2cpio "$rpmfile" | cpio -id 2>/dev/null

   rel_link="`dirname \"$6\"`/`basename \"$6\" .orig`"  
   if [ ! -h "$rel_link" ]
   then
      error "Failed to find $rel_link soft-link (couldn't install $fname)"
   fi
   
   rel_file="`dirname \"$6\"`/`readlink \"$rel_link\"`"
   if [ ! -s "$rel_file" ]
   then
      error "Failed to find $rel_file file (couldn't install $fname)"
   fi

   rm -f "$fname"
   cp -fp "$rel_file" "$fname"
   if [ -s "$fname" ]
   then
      change_se_context "$fname"
   else
      error "Failed to install $fname"
   fi
}

yesno()
# $1 = Message prompt
# Returns ans=0 for no, ans=1 for yes
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would be asked here if you wanted to"
      echo "$1 (y/n - y is assumed)"
      ans=1
   else
      ans=2
   fi

   while [ $ans -eq 2 ]
   do
      echo -n "Do you want to $1 (y/n) ?" ; read reply
      case "$reply" in
      Y*|y*) ans=1 ;;
      N*|n*) ans=0 ;;
          *) echo "Please answer y or n" ;;
      esac
   done
}

check_version()
# Make sure that we are running the latest version
# $* = Params passed to script
{
   message "Checking for an update to $scriptname" "n"
   download_file "$checkurl"

   if [ $dry_run -eq 1 ]
   then
      echo "Would check if this running script (version $version) is out of date."
      echo "If it's been superseded, the new version would be downloaded and you'd be asked"
      echo "if you want to upgrade to it and run the new version."
      echo
      return
   fi

   newversion="`cat \"$checkfile\"`"
   newversion="`echo $newversion`"
   rm -f "$checkfile"

   if [ "$newversion" = "$version" ]
   then
      message "$scriptname is already the latest version ($version) - continuing" "n"
   else
      message "New version ($newversion) of $scriptname detected - downloading it now"
      download_file "$upgradeurl"

      if [ "$scriptname" -ef "$script" ]
      then
         let a=1
      else
         mv -f "$scriptname" "$script"
      fi
      chmod u+x "$script"
      message "Download of $scriptname $newversion successful"

      yesno "run $scriptname $newversion now"
      if [ $ans -eq 1 ]
      then
         message "OK, executing $script $*"
         exec "$script" $*
         error "Failed to run $script $*"
      else
         if [ $quiet -lt 2 ]
         then
            echo
            echo "$scriptname $newversion is available as $script"
            echo "Please inspect the new code and then run the new script."
            echo
         fi
         clean_up
         exit 1
      fi
   fi
}

find_latest_chrome_version()
# Look on OmahaProxy CSV site or in yum repo for latest version number of linux/$csv_type/current
{
   message "Determining latest $chrome_name version number (please wait)" "n"
   chrome_latest=""

   # Do we have a Google Chrome RPM already installed and also
   # an enabled yum repo for it too?
   if [ "$chrome_installed" != "" -a "`yum repolist google-chrome enabled | grep ^google-chrome`" != "" ]
   then
      if [ $dry_run -eq 1 ]
      then
         echo "Would use yum check-update to determine if there was a later $chrome_name available."
         echo
         return
      fi

      # We have an enabled repo, do use check-update option to look for an update
      chrome_latest="`yum check-update google-chrome-$rpm_type | grep ^google-chrome-$rpm_type |
                      awk '{ print $2; }' | cut -d- -f1`"
   fi

   if [ "$chrome_latest" = "" ]
   then
      # No repo update, so now use OmahaProxy's current CSV to find latest version
      csv_name="chrome_versions.csv"
      download_file "$chrome_csv" "$csv_name"

      if [ $dry_run -eq 1 ]
      then
         echo "Would use OmahaProxy current CSV to determine latest $chrome_name version number"
         echo
         return
      fi

      if [ -s "$csv_name" ]
      then
         chrome_latest="`grep ^linux,$csv_type, \"$csv_name\" | head -1 | cut -d, -f3`"
      fi
      rm -f "$csv_name"
   fi

   if [ "$chrome_latest" = "" ]
   then
      warning "Unable to determine latest $chrome_name version number" "n"
   else
      message "Latest $rpm_name version number is $chrome_latest" "n"
      chrome_name="$chrome_name $chrome_latest"
   fi
}

get_installed_version()
# Find out what version of Google Chrome is installed
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would use \"$inst_tree/google-chrome --version\" or"
      echo "\"rpm -q $rpm_name\" to determine installed Google Chrome version"
      echo
      return
   fi

   # Look for the installed RPM first and get version from that
   chrome_installed="`is_installed $rpm_name | cut -d- -f4`"

   # If RPM not installed, see if we can use the shell wrapper for the version
   if [ "$chrome_installed" = "" -a -x "$inst_tree/google-chrome" ]
   then
      # This may fail of course if Google Chrome 28+ installed without Fedora libs
      chrome_installed="`\"$inst_tree/google-chrome\" --version 2>/dev/null | awk '{ print $3; }'`"
   fi

}

get_downloaded_version()
# Find out what version of Google Chrome RPM was downloaded
{
   if [ $dry_run -eq 1 ]
   then
      chrome_downloaded=""
      echo "Would use \"rpm -qp\" on downloaded Google Chrome RPM to find its version"
      echo
      return
   fi

   if [ -s $chrome_rpm ]
   then
      chrome_downloaded="`rpm -qp \"$chrome_rpm\" | cut -d- -f4`"
      if [ "$chrome_downloaded" = "" ]
      then
         error "Can't find version number of $chrome_rpm"
      fi
   else
      chrome_downloaded=""
   fi
}

download_chrome_rpm()
# Download latest RPM because we don't have it downloaded and don't have
# the latest release installed either
{
   download_file "https://dl.google.com/linux/direct/$chrome_rpm"
   get_downloaded_version

   if [ $dry_run -eq 1 ]
   then
      return
   fi

   if [ "$chrome_latest" = "" ]
   then
      chrome_latest="$chrome_downloaded"
   fi

   if [ "$chrome_downloaded" != "$chrome_latest" ]
   then
      # Downloaded version is different from what OmahaProxy claims is
      # the latest version, so we need to compare the four dot-separated
      # fields of the version numbers to judge which is the higher.
      dotfield=1
      while [ $dotfield -le 4 ]
      do
         dlfield="`echo $chrome_downloaded | cut -d. -f$dotfield`"
         ltfield="`echo $chrome_latest | cut -d. -f$dotfield`"
         if [ "$dlfield" != "" -a "$ltfield" != "" ]
         then
            if [ $dlfield -lt $ltfield ]
            then
               error "Downloaded Google Chrome RPM version ($chrome_downloaded) is older than the latest one ($chrome_latest)"
            else
               # If the downloaded version field is definitely higher, then
               # it's the new latest version and we exit the loop early
               if [ $dlfield -gt $ltfield ]
               then
                  chrome_latest="$chrome_downloaded"
                  dotfield=4
               fi
            fi
         fi
         let dotfield=$dotfield+1
      done
   fi

   message "$chrome_name downloaded successfully" "n"
}

install_chrome_rpm()
# We force install the RPM because CentOS 6's packages
# are below the minimum requirements now
{
   message "Installing $chrome_name RPM (please wait)"

   if [ $dry_run -eq 1 ]
   then
      echo "Would force-install $chrome_rpm RPM and"
      echo "then check the installed version number is the one it should be"
      return
   fi

   check_binary_not_running
   rm -f "$inst_tree/chrome"
   rpm $rpm_options "$chrome_rpm"
   if [ ! -x "$inst_tree/chrome" ]
   then
      error "Failed to install $chrome_name"
   else
      get_installed_version
      if [ "$chrome_installed" = "$chrome_latest" ]
      then
         message "$chrome_name installed successfully"
         install_success=1
      else
         error "Newly-installed Google Chrome version ($chrome_installed) not the latest one ($chrome_latest)"
      fi
   fi
}

update_google_chrome()
# Download and install the latest Google Chrome RPM
# if it's either out of date or not installed yet
{
   get_installed_version
   find_latest_chrome_version
   get_downloaded_version

   if [ $dry_run -eq 1 ]
   then
      echo "Would check if installed Google Chrome is the latest version."
      echo "If it isn't, the latest version would be downloaded and installed."
      echo
      return
   fi

   if [ "$chrome_installed" = "$chrome_latest" -a "$chrome_latest" != "" ]
   then
      message "$chrome_name is already installed - skipping installation"
      install_success=1
   else
      if [ "$chrome_downloaded" != "$chrome_latest" -o "$chrome_latest" = "" ]
      then
         download_chrome_rpm
      fi
      install_chrome_rpm
   fi
}

patch_libs()
# Hack references to $ld_linux.so.2 to be $ld_linux.so.0 in libc.so.6,
# $ld_linux.so.0, libstdc++.so.6 and libdl.so.2 so that we avoid picking up
# the system version in /$rellib (yes, there's a maddeningly hard-coded path
# in the ld library that ignores LD_LIBRARY_PATH).
{
   libc="$libdir/libc.so.6"
   libld="$libdir/$ld_linux$new_ld_suff"
   libcpp="$libdir/libstdc++.so.6"
   libdl="$libdir/libdl.so.2"

   if [ $dry_run -eq 1 ]
   then
      echo "Would patch downloaded $libc, $libld, $libcpp and"
      echo "$libdl to use $ld_linux$new_ld_suff and also"
      echo "set their SELinux context types if necessary."
      echo
      return
   fi

   for each_lib in "$libc" "$libld" "$libcpp" "$libdl"
   do
      each_lib_orig="$each_lib.orig"
      if [ -s "$each_lib_orig" ]
      then
         message "Patching $each_lib" "n"
         sed -e "s/$ld_linux.so.2/$ld_linux$new_ld_suff/g" <"$each_lib_orig" >"$each_lib"
         rm -f "$each_lib_orig"
         if [ -s "$each_lib" ]
         then
            chmod a+rx "$each_lib"
            change_se_context "$each_lib"
         else
            error "Failed to created patched $each_lib"
         fi
      else
         error "$each_lib_orig missing (didn't extract from Fedora RPM)"
      fi
   done
}

init_setup()
# Get everything setup and do a few basic checks
{
   if [ $quiet -lt 2 ]
   then
      echo "$chrome_name $inst_str $version on the $arch platform"
      echo "(C) Richard K. Lloyd `date +%Y` <rklloyd@gmail.com>"
      show_space_used
      echo
   fi

   if [ $dry_run -eq 1 ]
   then
      echo "Running in dry-run mode (-n) - none of the actions below will be performed."
      if [ $quiet -ne 0 ]
      then
         echo "Please note that combining dry-run and quiet modes isn't a good idea,"
         echo "but I'll continue anyway just to keep you happy."
      fi
      echo
   fi

   # Must run this script as root
   if [ `id -u` -ne 0 ]
   then
      error "You must run $scriptname as the superuser (usually root)"
   fi

   if [ "$tmp_tree" = "" -o "$tmp_tree" = "/tmp" -o "$tmp_tree" = "/" ]
   then
      error "Temporary directory location ($tmp_tree) incorrect"
   fi

   if [ $do_install -eq 0 ]
   then
      return
   fi

   if [ $dry_run -eq 1 ]
   then
      if [ ! -d "$tmp_tree" ]
      then
         echo "Would create temporary $tmp_tree directory"
      fi
      echo "Would change working directory to $tmp_tree"
      echo
   else
      if [ ! -d "$tmp_tree" ]
      then
         message "Creating temporary directory $tmp_tree" "n"
         mkdir -p "$tmp_tree"
         if [ ! -d "$tmp_tree" ]
         then
            error "Couldn't create $tmp_tree directory"
         fi
      fi

      message "Changing working directory to $tmp_tree" "n"
      cd /
      cd "$tmp_tree"
      if [ "`pwd`" != "$tmp_tree" ]
      then
         error "Couldn't change working directory to $tmp_tree"
      fi
   fi
}

check_derivative()
# A rather naff check for version 6 of OS and 2.6 kernel
{
   if [ "`grep 6 /etc/issue 2>/dev/null`" = "" ]
   then
      case "`uname -r`" in
      2.6.*) let a=1 ;;
          *) echo
             echo "This OS doesn't look like it's in the RHEL 6 family."
             echo "Very bad things could happen if you continue!"
             echo
             yesno "you want to continue"
             if [ $ans -eq 1 ]
             then
                message "OK, but you've been warned, so remember that"
             else
                error "Probably a wise move"
             fi ;;
      esac
   fi
}

yum_install()
# Download and Install specified packages if they aren't already installed
# $1   = "prompt" Prompt if any of $2.. aren't already installed
# $2.. = List of packages to install
{
   # Nothing to install yet
   install_list=""

   if [ "$1" = "prompt" ]
   then
      prompt=1 ; promptstr="ask for"
   else
      prompt=0 ; promptstr="proceed with" ; ans=1
   fi
   shift

   for each_dep in $*
   do
      if [ "`is_installed $each_dep`" = "" ]
      then
         install_list="$install_list $each_dep"
      else
          if [ "$each_dep" = "libX11" ]
          then
             # Need libX11 1.5* or later, so check for that.
             # OS upgrade would move to 1.5+ anyway, so probably not needed
             case "`rpm -q --queryformat '%{VERSION}' $each_dep`" in
             1.3*|1.4*) install_list="$install_list $each_dep" ;;
             esac
          fi
      fi
   done

   if [ "$install_list" != "" ]
   then
      if [ $dry_run -eq 1 ]
      then
         echo "Would $promptstr the installation of these packages and their dependencies:"
         echo "$install_list"
         echo
         return
      fi
          
      echo "The following packages and their dependencies need downloading/installing:"
      echo "$install_list"
      if [ $prompt -eq 1 ]
      then
         echo
         yesno "download/install these packages and dependencies"
      fi

      if [ $ans -eq 1 ]
      then
         message "Downloading/installing $install_list (please wait)"
         yum $yum_options install $install_list
      else
         error "Those packages are required by this script"
      fi
   fi
}

check_if_os_obsolete()
# If OS version is less than 6.4, offer to upgrade (and abort if declined).
# We need at least 6.4 because bad things happen in earlier versions
{
   os_version="`lsb_release -rs`"
   case "$os_version" in
   6.0|6.1|6.2|6.3)
      if [ $dry_run -eq 1 ]
      then
         echo "Would offer to upgrade your out-of-date OS (version $os_version)."
         echo "If declined, user is warned that they must upgrade their OS and reboot"
         echo "before running $chrome_name."
         echo
         return
      fi

      echo "Your OS version ($os_version) is out-of-date and will probably not"
      echo "run $chrome_name correctly."
      echo
      yesno "upgrade your OS"

      if [ $ans -eq 1 ]
      then
         message "Upgrading OS to latest release" "n"
         message "You will have a final y/n prompt before updates are downloaded/installed"
         yum update
         new_os_version="`lsb_release -rs`"
         if [ "$new_os_version" = "$os_version" ]
         then
            ans=0
            warning "You declined an OS update to the latest release"
         else
            message "Upgrade to OS version $new_os_version completed successfully"
            echo "You are STRONGLY RECOMMENDED to reboot this machine to run the new $new_os_version kernel."
            echo "If you don't, it's likely $chrome_name will not run correctly."
            echo "Please close all applications now (except this script!) if you want to reboot."
            warning "These users are logged into this machine: `users | tr ' ' '\n' | sort -u`"
          
            yesno "reboot this machine immediately"
            if [ $ans -eq 1 ]
            then
               message "Rebooting machine now"
               /sbin/shutdown -r now
               exit 0
            fi
            warning "Do not run $chrome_name until after the next reboot"
            ans=1
         fi
      fi

      if [ $ans -eq 0 ]
      then
         warning "$chrome_name should not be run until you upgrade this machine's OS via \"yum update\" and reboot it after the upgrade"
      fi ;;
   esac
}

install_rpm_libraries()
# Extract and install libraries from Fedora RPMs
{
   # We need to create library dir because we haven't installed
   # the Google Chrome RPM yet
   if [ ! -d "$libdir" ]
   then
      mkdir -p -m 755 "$libdir"
      if [ ! -d "$libdir" ]
      then
         error "Can't create $chrome_name library dir ($libdir)"
      fi
   fi

   # Function       RPM core filename               64-bit cksum  64-bit size  32-bit cksum  32-bit size  Relative soft-link unpacked     Optional rename
   install_library  libstdc++-4.6.3-2.fc$fedver     493778044     295501       1671666549    308213       $relusrlib/libstdc++.so.6       libstdc++.so.6.orig
   install_library  glibc-2.14.1-6                  841490955     3504537      3942597577    4011933      $rellib/libc.so.6               libc.so.6.orig
   install_library  glibc-2.14.1-6                  841490955     3504537      3942597577    4011933      $rellib/$ld_linux.so.2          $ld_linux$new_ld_suff.orig
   install_library  glibc-2.14.1-6                  841490955     3504537      3942597577    4011933      $rellib/libdl.so.2              libdl.so.2.orig
   install_library  gtk2-2.24.7-3.fc$fedver         1171472316    3401761      2066307093    3404053      $relusrlib/libgdk-x11-2.0.so.0
   install_library  gtk2-2.24.7-3.fc$fedver         1171472316    340176       2066307093    3404053      $relusrlib/libgtk-x11-2.0.so.0
   install_library  glib2-2.28.8-1.fc$fedver        4259542939    1813252      365790344     1794500      $rellib/libgio-2.0.so.0
   install_library  glib2-2.28.8-1.fc$fedver        4259542939    1813252      365790344     1794500      $rellib/libglib-2.0.so.0
   install_library  glib2-2.28.8-1.fc$fedver        4259542939    1813252      365790344     1794500      $rellib/libgobject-2.0.so.0
   install_library  gdk-pixbuf2-2.23.3-2.fc$fedver  1494219476    508020       746431589     506948       $relusrlib/libgdk_pixbuf-2.0.so.0
}

bulk_warning()
# Multi-line warning message in $1, $2 and $3
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would display this warning to stderr:"
      echo "$1"
      echo "$2"
      echo "$3"
   else
      echo >&2
      echo "WARNING:" >&2
      echo "$1" >&2
      echo "$2" >&2
      echo "$3." >&2
   fi
}

final_messages()
# Display final installation messages before exiting
{
   if [ $quiet -eq 2 -o $do_install -eq 0 ]
   then
      return
   fi

   echo
   if [ $dry_run -eq 1 ]
   then
      echo "Would display these final messages after a successful run:"
      echo
   fi

   echo "$chrome_name and Fedora $fedver libraries installed successfully."
   echo "Please run the browser via the 'google-chrome' command as a non-root user."
   echo

   echo "To update Google Chrome, run \"yum update $rpm_name\" or"
   echo "simply re-run this script with \"./$scriptname\"."
   echo
   echo "To uninstall Google Chrome and its dependencies added by this script,"
   echo "run \"yum remove $rpm_name $deps_name\" or \"./$scriptname -u\"."
   echo
}

parse_options()
# Parse script options passed as $*
{
   delete_tmp=0 ; dry_run=0 ; do_install=1
   quiet=0 ; inst_str="Installer"
   risky_type="$old_rpm_type"

   while [ "x$1" != "x" ]
   do
      case "$1" in
      -\?|-h|--help)  show_syntax ; exit 0 ;;
      -b|--beta)      risky_type="beta" ;;
      -d|--delete)    delete_tmp=1 ;;
      -n|--dryrun)    dry_run=1 ;;
      -q|--quiet)     if [ $quiet -lt 2 ]
                      then
                        let quiet=$quiet+1
                      fi ;;
      -s|--stable)    risky_type="stable" ;;
      -t|--tmpdir)    shift ; set_tmp_tree "$1" ;;
      -u|--uninstall) do_install=0 ; inst_str="Uninstaller" ;;
      -U|--unstable)  risky_type="unstable" ;;
       *)             show_syntax >&2
                      error "Invalid option ($1)" ;;
      esac
      shift
   done

   if [ $quiet -ne 0 ]
   then
      wget_options="$wget_options -q"
      yum_options="$yum_options -q"
      rpm_options="$rpm_options --quiet"
      rpmbuild_options="$rpmbuild_options --quiet"
   else
      rpm_options="$rpm_options -vh"
      chcon_options="$chcon_options -v"
   fi

   if [ "$risky_type" != "$old_rpm_type" ]
   then
      set_rpm_type "$risky_type"
   fi
}

create_spec_file()
# Create chrome-deps.spec file for building the chrome-deps RPM.
# Many thanks to to Marcus Sandberg for his (public domain) spec file at
# https://github.com/adamel/chrome-deps which I have used as a basis for the
# spec file that this script creates.
{
   ( cat <<@EOF
# Much of this spec file was taken from Marcus Sandberg's fine (public domain)
# effort at https://github.com/adamel/chrome-deps although it has been
# modified compared to his version.

Name:		@DEPS_NAME@
Version:	@DEPS_VERSION@
Release:	1
Summary:	Dependencies required for Google Chrome 28+ on RHEL 6 derivatives
License:	LGPLv2+, LGPLv2+ with exceptions, GPLv2+, GPLv3+, GPLv3+ with exceptions, GPLv2+ with exceptions, BSD, public domain
Group:		System Environment/Libraries
URL:		@CHECKSITE@
Vendor:         Richard K. Lloyd and the Fedora Project
Packager:       Richard K. Lloyd <rklloyd@gmail.com>
BuildRoot:	@BUILDROOT@

%description
Includes modified Fedora @FEDVER@ Libraries (@LD_LINUX@, libc, libdl,
libgdk-x11-2.0, libgdk_pixbuf-2.0, libgio-2.0, libglib-2.0, libgobject-2.0,
libgtk-x11-2.0 and libstdc++) and an LD_PRELOAD library (unset_var.so).
Also modifies Google Chrome's @CHROME_WRAPPER@ wrapper script to allow
Google Chrome 28 or later to run on RHEL 6 derivatives. SELinux enforcing mode
will cause startup issues, so it is recommended you switch SELinux to
permissive mode in that case. The URL for the script that downloaded, modified
and re-packaged the Fedora @FEDVER@ libraries in this RPM is
@CHECKSITE@@SCRIPTNAME@
and it is in the public domain.

# List of libraries to include in the RPM
%files
%defattr(-,root,root,-)
@MODIFY_WRAPPER@
@LIBDIR@/@LD_LINUX@.so.0
@LIBDIR@/libc.so.6
@LIBDIR@/libdl.so.2
@LIBDIR@/libgdk-x11-2.0.so.0
@LIBDIR@/libgdk_pixbuf-2.0.so.0
@LIBDIR@/libgio-2.0.so.0
@LIBDIR@/libglib-2.0.so.0
@LIBDIR@/libgobject-2.0.so.0
@LIBDIR@/libgtk-x11-2.0.so.0
@LIBDIR@/libstdc++.so.6
@LIBDIR@/unset_var.so

# No prep or build rules because it's all been done by @SCRIPTNAME@

# Install a copy of libraries into build root
%install
rm -rf %{buildroot}
mkdir -p -m 755 %{buildroot}@LIBDIR@
cp -pf @MODIFY_WRAPPER@ %{buildroot}@INST_TREE@
cp -pf @LIBDIR@/*.so.* @LIBDIR@/unset_var.so %{buildroot}@LIBDIR@/

# Run modify_wrapper once the files are installed
%post
@MODIFY_WRAPPER@

# At end of build, remove build root
%clean
rm -rf %{buildroot}

# Changelog, with annoyingly "wrong" US date format
%changelog
* Wed Dec 11 2013 Richard K. Lloyd <rklloyd@gmail.com> - 1.10-1
- Additionally saved/unset/restored the LD_PRELOAD environmental
  variable in unset_var.c to stop exec'ed() processes using it.
* Sat Oct  5 2013 Richard K. Lloyd <rklloyd@gmail.com> - 1.03-1
- Added libgdk_pixbuf-2.0.so.0, extracted from the gdk-pixbuf2
  Fedora @FEDVER@ RPM.
* Fri Oct  4 2013 Richard K. Lloyd <rklloyd@gmail.com> - 1.02-1
- Added libgio-2.0 and libgobject-2.0 to the set of included
  Fedora @FEDVER@ libraries.
* Thu Aug  8 2013 Richard K. Lloyd <rklloyd@gmail.com> - 1.01-1
- Updated unset_var.c to fix Google Talk Plugin crash.
* Sun Jul 28 2013 Richard K. Lloyd <rklloyd@gmail.com> - 1.00-1
- Initial version based on Marcus Sandberg's fine work at
  https://github.com/adamel/chrome-deps (differences are below).
- All the Fedora @FEDVER@ library downloads, unpacking and modifications are
  done in the @SCRIPTNAME@ script that generated this spec file, rather
  than run as spec file commands.
- LD_PRELOAD @UNSETLIB@ library and @MODIFY_WRAPPER@
  script are both included in the built RPM.
@EOF
   ) | sed \
   -e "s#@DEPS_VERSION@#$deps_version#g" \
   -e "s#@LD_LINUX@#$ld_linux#g" \
   -e "s#@DEPS_NAME@#$deps_name#g" \
   -e "s#@CHECKSITE@#$checksite#g" \
   -e "s#@FEDVER@#$fedver#g" \
   -e "s#@SCRIPTNAME@#$scriptname#g" \
   -e "s#@LIBDIR@#$libdir#g" \
   -e "s#@UNSETLIB@#`basename $unsetlib`#g" \
   -e "s#@CHROME_WRAPPER@#`basename $chrome_wrapper`#g" \
   -e "s#@MODIFY_WRAPPER@#$modify_wrapper#g" \
   -e "s#@INST_TREE@#$inst_tree#g" \
   -e "s#@BUILDROOT@#$rpmbuilddir/BUILDROOT#g" \
   >"$specfile"
}

setup_build_env()
# Create RPM build environment under ~/rpmbuild and also
# create the chrome-deps.spec file
{
   rpmbuilddir=~/rpmbuild
   built_rpm="$rpmbuilddir/RPMS/$rpmarch/$built_rpm_base"
   specsdir="$rpmbuilddir/SPECS"
   specfile="$specsdir/$deps_name.spec"
   setuptree="/usr/bin/rpmdev-setuptree"

   if [ $dry_run -eq 1 ]
   then
      echo "Would create the build environment tree ($rpmbuilddir)"
      echo "and also the $deps_name spec file ($specfile)."
      echo
      return
   fi

   if [ ! -d "$specsdir" ]
   then
      if [ -x "$setuptree" ]
      then
         $setuptree
      fi

      if [ ! -d "$specsdir" ]
      then
         error "Unable to correctly run $setuptree to create build enviroment"
      fi
   fi
}

build_deps_rpm()
# Create chrome-deps RPM from the chrome-deps.spec file and install it
{
   built_rpm_base="$deps_name-$deps_version-1.$rpmarch.rpm"
   tmpdir_rpm="$tmp_tree/$built_rpm_base"

   # Only build latest chrome-deps RPM if we haven't already got it
   if [ ! -s "$tmpdir_rpm" ]
   then
      # Get ready for RPM build
      setup_build_env

      # Create chrome-deps.spec file
      create_spec_file

      if [ $dry_run -eq 1 ]
      then
         echo "Would run rpmbuild to create $tmpdir_rpm"
         echo
      else
         cd "$specsdir"
         message "Building $tmpdir_rpm"
         rm -f "$tmpdir_rpm"

         rpmbuild $rpmbuild_options "`basename \"$specfile\"`"
         rm -f "$specfile"

         # Some users claim that the i386 build tree is actually i686,
         # but that's doesn't happen for me in CentOS or Scientific Linux.
         # Still, let's check for it anyway
         if [ ! -s "$built_rpm" -a "$rpmarch" = "i386" ]
         then
            built_rpm_base="$deps_name-$deps_version-1.i686.rpm"
            built_rpm="$rpmbuilddir/RPMS/i686/$built_rpm_base"
            # We don't change tmpdir_rpm, so this handily renames
            # the final RPM to an i386-based filename below
         fi

         if [ -s "$built_rpm" ]
         then
            mv -f "$built_rpm" "$tmpdir_rpm"
            built_rpm="$tmpdir_rpm"
         fi

         if [ ! -s "$built_rpm" ]
         then
            error "Failed to build $tmpdir_rpm"
         fi
      fi
   fi

   if [ $dry_run -eq 1 ]
   then
      echo "Would install $tmpdir_rpm"
      echo
   else
      message "Installing $tmpdir_rpm"
      rpm $rpm_options "$tmpdir_rpm"
   fi
}

adjust_chrome_defaults()
# Create a modify_wrapper script to be included in chrome-deps that modifies
# /etc/default/google-chrome if necessary to doing the following:
# - Remove any existing setting of repo_add_once
# - Updates (or adds) a custom ### START .. ### END section, which will
#   add an LD_PRELOAD definition to google-chrome if one isn't present.
# - Sets repo_add_once to true (picked up by /etc/cron.daily/google-chrome)
# modify_wrapper is run once at the end of the chrome-deps RPM installation.
{
   if [ $dry_run -eq 1 ]
   then
      echo "Would create a modify_wrapper script to modify $chrome_defaults."
      echo "The script would ensure the creation of $chrome_repo and"
      echo "the addition of a LD_PRELOAD variable to $chrome_wrapper."
      echo
      return
   fi

   ( cat <<@EOF
#! /bin/bash
# @MODIFY_WRAPPER@ @WRAPPER_MOD_VERSION@ (C) Richard K. Lloyd 2013 <rklloyd@gmail.com>
# Created by @SCRIPTNAME@ and included in the @DEPS_NAME@ RPM
# to modify @CHROME_DEFAULTS@ in the following ways:
# - Remove any existing setting of repo_add_once
# - Updates (or adds) a custom ### START .. ### END section, which will
#   add an LD_PRELOAD definition to google-chrome if one isn't present.
# - Sets repo_add_once to true (picked up by /etc/cron.daily/google-chrome)
# @MODIFY_WRAPPER@ is run once at the end of the @DEPS_NAME@ RPM installation.

chrome_defaults="@CHROME_DEFAULTS@"
progname="\`basename \$0\`"

error()
{
   echo "\$progname: ERROR: \$1 - aborted" >&2
   exit 1
}

# Create defaults file if it doesn't exist
touch "\$chrome_defaults"
if [ ! -f "\$chrome_defaults" ]
then
   error "Can't create \$chrome_defaults"
fi

update_file()
# \$1 = File to update with contents of stdin
{
   nfile="\$1.new" ; ofile="\$1.old"
   cat >"\$nfile"
   if [ ! -f "\$nfile" ]
   then
      rm -f "\$nfile"
      error "Failed to create temporary update file \$nfile"
   fi

   # Don't do update if new file is the same as old one
   if [ "\`diff \"\$1\" \"\$nfile\"\`" = "" ]
   then
      rm -f "\$nfile"
      return
   fi

   mv -f "\$1" "\$ofile"
   if [ ! -f "\$ofile" ]
   then
      error "Failed to create temporary backup of \$1"
   fi

   mv -f "\$nfile" "\$1"
   rm -f "\$nfile"
   if [ ! -f "\$1" ]
   then
      mv -f "\$ofile" "\$1"
      chmod a+r "\$1"
      error "Failed to update \$1"
   fi
   
   chmod a+r "\$1"
   rm -f "\$ofile"
}

grep -v repo_add_once= "\$chrome_defaults" | awk '
BEGIN { wrapper_mod=0; exclude_mod=0; end_of_mod=0; }
{
   if (\$4==scriptname)
   {
      if (\$2=="START")
      {
         if (\$3==wrapper_mod_version)
         {
            wrapper_mod=1; exclude_mod=0;
         }
         else exclude_mod=1;
      }
      else
      if (\$2=="END") end_of_mod=1;
   }

   if (!exclude_mod) printf("%s\n",\$0);

   if (end_of_mod) { exclude_mod=0; end_of_mod=0; }
}
END {
   if (!wrapper_mod)
   {
      printf("### START %s %s modifications\n",
             wrapper_mod_version,scriptname);
      printf("old_line=\"export LD_LIBRARY_PATH\"\n");
      printf("new_line=\"\$old_line LD_PRELOAD=\\\\\"%s\\\\\"\"\n",unsetlib);
      printf("chrome_wrapper=\"%s\"\n",chrome_wrapper);
      printf("if [ -s \"\$chrome_wrapper\" ]\n");
      printf("then\n");
      printf("   if [ \"\`grep \\\\\"\$new_line\\\\\" \\\\\"\$chrome_wrapper\\\\\"\`\" = \"\" ]\n");
      printf("   then\n");
      printf("      new_wrapper=\"\$chrome_wrapper.new\"\n");
      printf("      sed -e \"s#\$old_line#\$new_line#g\" <\"\$chrome_wrapper\" >\"\$new_wrapper\"\n");
      printf("      if [ -s \"\$new_wrapper\" ]\n");
      printf("      then\n");
      printf("         mv -f \"\$new_wrapper\" \"\$chrome_wrapper\"\n");
      printf("         chmod a+rx \"\$chrome_wrapper\"\n");
      printf("      fi\n");
      printf("   fi\n");
      printf("fi\n");
      printf("### END %s %s modifications\n",
             wrapper_mod_version,scriptname);
   }
   printf("repo_add_once=\"true\"\n");
}' \
wrapper_mod_version="@WRAPPER_MOD_VERSION@" scriptname="@SCRIPTNAME@" \
unsetlib="@UNSETLIB@" chrome_wrapper="@CHROME_WRAPPER@" |
update_file "\$chrome_defaults"

# Now actually run the defaults file (it will be run daily via cron or
# when the google-chrome-stable RPM is installed or updated),
# so that google-chrome is updated if it needs to be
if [ -s "\$chrome_defaults" ]
then
   . "\$chrome_defaults"
fi

exit 0
@EOF
) | sed \
   -e "s#@MODIFY_WRAPPER@#`basename \"$modify_wrapper\"`#g" \
   -e "s#@WRAPPER_MOD_VERSION@#$wrapper_mod_version#g" \
   -e "s#@SCRIPTNAME@#$scriptname#g" \
   -e "s#@DEPS_NAME@#$deps_name#g" \
   -e "s#@CHROME_DEFAULTS@#$chrome_defaults#g" \
   -e "s#@DEPS_NAME@#$deps_name#g" \
   -e "s#@UNSETLIB@#$unsetlib#g" \
   -e "s#@CHROME_WRAPPER@#$chrome_wrapper#g" \
   >"$modify_wrapper"

   if [ -s "$modify_wrapper" ]
   then
      chmod a+rx "$modify_wrapper"
      change_se_context "$modify_wrapper"
      message "Created $modify_wrapper sucessfully"
   else
      error "Failed to create $modify_wrapper"
   fi
}

main_code()
# Initialisation complete, so run the code
{
   if [ $do_install -eq 1 ]
   then
      # Only install RPM-building packages if latest chrome-deps isn't installed
      if [ "$deps_latest" = "" ]
      then
         rpm_build_packages="gcc glibc-devel rpm-build rpmdevtools"
      else
         rpm_build_packages=""
      fi

      # Make sure google-chrome-stable and chrome-deps dependencies are present
      # but prompt for their download/install if any aren't 
      yum_install prompt redhat-lsb wget xdg-utils GConf2 libXScrnSaver libX11 $rpm_build_packages

      # Now update Google Chrome if necessary
      update_google_chrome

      if [ "$deps_latest" = "" ]
      then
         # Download/install/patch Fedora libraries
         install_rpm_libraries
         patch_libs

         # Adjust /etc/default/google-chrome (sourced in daily by
         # /etc/cron.daily/google-chrome) as required
         adjust_chrome_defaults

         # Build/install LD_PRELOAD library if latest chrome-deps not installed
         install_ld_preload_lib

         # Build and install the chrome-deps RPM if the latest isn't installed
         build_deps_rpm

         # That's the end of $libdir changes, so change its SELinux context type
         change_se_context "$libdir"
      fi
   else
      # If it's installed, uninstall Google Chrome and dependency packages
      check_binary_not_running
      uninstall_google_chrome
   fi
}

check_selinux()
# See if SELinux is enabled and if it's enforcing
{
   selinux_enforcing=0 ; selinux_enabled=0

   # Yes, there's a value-returning util (0=enabled, ho hum, so we flip it)
   # but it may not exist, so fallback on /selinux dir existence
   if [ -x /usr/sbin/selinuxenabled ]
   then
      /usr/sbin/selinuxenabled
      let selinux_enabled=1-$?
   else
      if [ -d /selinux ]
      then
         selinux_enabled=1
      fi
   fi

   if [ $selinux_enabled -eq 1 ]
   then
      # Enforcing mode upsets nacl_helper, so try to see if we're using it
      if [ -f /selinux/enforce ]
      then
         selinux_enforcing="`cat /selinux/enforce`"
      fi
   fi
}

# Initialisation functions
init_vars $0
check_derivative
check_selinux
parse_options $*
check_binary_not_running
init_setup
check_version $*

# Now do the install or uninstall
main_code

# Finalisation functions
clean_up
final_messages

if [ $do_install -eq 1 ]
then
   # Need at least version 6.4 of OS to run Google Chrome successfully
   check_if_os_obsolete
fi

# A good exit
exit 0
