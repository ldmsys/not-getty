# Not Getty
## What is this?
This is not getty.
![image](https://user-images.githubusercontent.com/16889349/155854341-1075097c-5277-4bb5-986e-e5b36e94b3b3.png)

It's just bootloader that looks like *nix's login screen for no purpose.

## Usage
> $ nasm notgetty.S -f bin -o notgetty.bin
>
> $ qemu-img convert -O vpc notgetty.bin notgetty.vhd
>
> $ qemu-system-i386 -m 128 -hda notgetty.vhd

## License
[GPLv2](./LICENSE).

## Disclaimer
 * Operating System's names mentioned in source code may be a trademark of respective owners.
 * License of this source code is GPLv2(or later) because some texts are may be from GPLed-source code. (for compatibility purposes)
 * Apply pd-transition.patch to use this source in condition of [Unlicense](https://unlicense.org/).
