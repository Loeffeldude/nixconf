for config_file in ~/.bashrc.d/**/*.sh; do
  [ -f "$config_file" ] && source "$config_file"
done

if [ -d ~/.sharedrc.d ]; then
  for i in ~/.sharedrc.d/**/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi
