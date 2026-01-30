<p align="center">  
  <img width="50%" src="assets/banner.svg">
  <h3 align=center></h3>
</p>

#
**PixTTF** is an app to create and edit pixel fonts powered by [Zig](https://github.com/ziglang/zig) and [DVUI](https://github.com/david-vanderson/dvui)

# Currently supported features
- [ ] Import TTF
- [ ] Export TTF
- [ ] Multiple sizes and weights for a single TTF
- [ ] Unicode support
- [ ] Character/glyph editor
- [ ] Typical pixel art operations (draw, erase, dropper, bucket, selection, transformation, etc)
- [ ] Text preview
- [ ] Infinite undo and redo history
- [ ] Auto-crash detection
- [ ] Theming
- [ ] Tutorial
- [ ] Saving text preview as PNG
- [ ] Importing and exporting other formats (such as OTF)
- [ ] Copying characters to alternative versions
- [ ] Autosave


# Compile
> [!NOTE]
> If you're on Linux ensure `gtk+3-devel` or similar is installed (for native file dialogs)

- Install Zig 0.15.2
- Clone Pixttf
- Run `zig build`

# Credits
- [Sergi Lázaro](https://sergilazaro.com/) for creating [PixelForge](https://pixel-forge.com) the inspiration for this project.
- [David Vanderson](https://github.com/david-vanderson) for [DVUI](https://github.com/david-vanderson/dvui) and all the help!
- [Foxnne](https://github.com/foxnne) for creating [Pixi](https://github.com/foxnne/pixi) which many of Pixtff design choices are based off from.
