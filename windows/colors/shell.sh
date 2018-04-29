#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0000000
  \e]P1c43f5c
  \e]P25cc43f
  \e]P3c4a73f
  \e]P43f5cc4
  \e]P5a73fc4
  \e]P63fc4a7
  \e]P7ffffff
  \e]P82d2d2d
  \e]P9e2a1af
  \e]PAafe2a1
  \e]PBe2d4a1
  \e]PCa1afe2
  \e]PDd4a1e2
  \e]PEa1e2d4
  \e]PFffffff
  "
  # get rid of artifacts
  clear
fi
