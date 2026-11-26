# GRUB theme mimicking the stock look of the Ly display manager:
# black background, white text, a single white-bordered box, key hints top-left.
{
  runCommand,
  grub2,
  imagemagick,
  terminus_font_ttf,
}:
runCommand "grub-theme-ly"
  {
    nativeBuildInputs = [
      grub2
      imagemagick
    ];
  }
  ''
    mkdir -p $out
    cp ${./theme.txt} $out/theme.txt

    fonts=${terminus_font_ttf}/share/fonts/truetype
    grub-mkfont -n Terminus -s 32 -o $out/terminus-32.pf2 $fonts/TerminusTTF.ttf
    grub-mkfont -n Terminus -s 32 -o $out/terminus-bold-32.pf2 $fonts/TerminusTTF-Bold.ttf

    # Menu box (styled_box): 2px white edges/corners, black center.
    for p in nw n ne e se s sw w; do
      magick -size 2x2 xc:'#ffffff' PNG32:$out/box_$p.png
    done
    magick -size 2x2 xc:'#000000' PNG32:$out/box_c.png

    # Selected entry: solid white bar (text drawn black on top), like Ly's highlight.
    magick -size 2x2 xc:'#ffffff' PNG32:$out/select_c.png
  ''
