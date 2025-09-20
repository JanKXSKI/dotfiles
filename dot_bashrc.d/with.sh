with() {
  previousWiths=$withs
  export withs="$withs${withs:+ }$1"; shift
  previousPS1=$PS1
  export PS1="\w ($withs) $ "
  bash --init-file <(echo trap \"$@\" EXIT) -i
  PS1=$previousPS1
  withs=$previousWiths
}

export -f with

wmnt() {
  mkdir ${@: -1}
  sudo mount $@
  with mnt sudo umount ${@: -1}; rmdir ${@: -1}
}

export -f wmnt

wnbdmnt() {
  sudo qemu-nbd -c $2 $1
  sleep .1 
  mkdir $3
  sudo mount $2 $3
  with nbdmnt sudo umount $(realpath $3); rmdir $(realpath $3); sudo qemu-nbd -d $2
}

wdck() {
  export wdckComposeFile=$(realpath $1)
  sudo podman compose -f $1 up -d ${@:2}
  with dck sudo podman compose -f $(realpath $1) down
}

export -f wdck

idck() {
  sudo podman compose -f $wdckComposeFile exec $1 bash
}

export -f idck

ldck() {
  sudo podman compose -f $wdckComposeFile logs -f $1
}

export -f ldck

