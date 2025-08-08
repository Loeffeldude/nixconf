if [ -d ~/.zshrc.d/ ]; then
  for i in ~/.zshrc.d/**/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

if [ -d ~/.sharedrc.d ]; then
  for i in ~/.sharedrc.d/**/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi
