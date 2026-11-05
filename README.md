# g3d-cube-tools

**🇧🇷 Português** · **🇺🇸 English** (below)

Coleção de ferramentas para o [g3d](https://github.com/groverburger/g3d) 1.6.0 (LÖVE 11.4+), feitas por **generico_cube**:

| Ferramenta | O que faz | Onde fica | Docs |
|---|---|---|---|
| **g3d-iluminacao** | Luz em tempo real: sol com sombras, luzes de ponto, spot e direcional, neblina, toon, presets de qualidade | `g3d-cube-tools/g3d-iluminacao/` | [iluminacao.md](g3d-cube-tools/docs/iluminacao.md) |
| **som3d** | Áudio espacial 3D (distância, Doppler, filtros, reverb) | `g3d-cube-tools/som3d/` | [som3d.md](g3d-cube-tools/docs/som3d.md) |
| **g3d-glb** | Carrega `.glb` com cores, texturas e animações de esqueleto | `g3d-cube-tools/g3d-glb/` | [glb.md](g3d-cube-tools/docs/glb.md) |
| **g3d-interface-e-entrada** | Interface (botão, joystick, touchpad, slider, texto...), entrada unificada (teclado, mouse, toque, gamepad) e clique em objetos 3D. PC e celular | `g3d-cube-tools/g3dui/` | [interface.md](g3d-cube-tools/docs/interface.md) |

## Organização

```
g3d/                  <- g3d do groverburger (terceiros, com 2 correções pequenas)
g3d-cube-tools/       <- TUDO que é do generico_cube
├── g3d-iluminacao/
├── som3d/
├── g3d-glb/
├── g3dui/
├── demos/            (menu + demos de cada ferramenta, podem ser apagadas)
└── docs/
main.lua, conf.lua    <- só abrem o menu de demos (`love .`)
```

## Como usar tudo

Baixe este repositório e copie para o seu projeto as pastas `g3d/` e `g3d-cube-tools/`.

```lua
local g3d = require "g3d"
local glb = require "g3d-cube-tools.g3d-glb"
local som3d = require "g3d-cube-tools.som3d"
local Lighting = require "g3d-cube-tools.g3d-iluminacao"
local ui = require "g3d-cube-tools.g3dui"
```

## Como usar só uma ferramenta

Todas dependem apenas da pasta `g3d/`. Copie `g3d/` e a pasta da ferramenta, mantendo-a dentro de `g3d-cube-tools/`:

- **g3d-iluminacao**: `g3d/` + `g3d-cube-tools/g3d-iluminacao/`
- **som3d**: `g3d/` + `g3d-cube-tools/som3d/`
- **g3d-interface-e-entrada**: `g3d/` + `g3d-cube-tools/g3dui/` (o `g3d/` só é necessário para clicar em objetos 3D)
- **g3d-glb**: `g3d/` + `g3d-cube-tools/g3d-glb/`

## Demos

Rode a raiz com LÖVE (`love .`) e escolha no menu (teclado, mouse ou toque): `1` iluminação, `2` som3d, `3` glb, `4` interface e entrada.
`F10` dentro de uma demo volta ao menu. Os controles de cada demo estão nos docs de cada ferramenta.
As demos ficam em `g3d-cube-tools/demos/` e podem ser apagadas sem afetar as ferramentas.

## Testar no celular

As demos funcionam com **controles de toque** (joystick = `W A S D`, arrastar a metade direita = olhar com o mouse, botões `Up`/`Down` = espaço/shift, botão `Keys` = teclas da demo, botão `Menu` = `F10`). Eles ligam sozinhos no celular. No PC, ligue a opção "Controles de toque" no menu antes de abrir a demo para visualizar.

1. Instale o LÖVE no celular (Android: [love2d.org](https://love2d.org), versão 11.4 ou mais nova).
2. Compacte o **conteúdo** da pasta (não a pasta em si) em um `.zip` e renomeie para `.love`. O `main.lua` precisa ficar na **raiz** do zip.
3. Copie o arquivo para o celular e abra com o LÖVE.

O iOS não foi testado: o LÖVE para iOS precisa ser compilado com o Xcode, e o mesmo `.love` serve.

## Mudanças no núcleo g3d

O núcleo (`g3d/`) é o mesmo nos projetos originais. Aqui há duas correções pequenas:

- `camera.lookAt` calculava direção/pitch com os eixos errados (z é o eixo vertical), o que fazia a câmera pular ao olhar com o mouse depois de um `lookAt`.
- `objloader`: aceita índices negativos do `.obj`, dá erro claro para índices inexistentes, não reaproveita o mesmo vértice entre triângulos de quads e gera normal plana para faces sem normais.

## Licença

MIT (veja `LICENSE`). O g3d é de groverburger, também MIT (`g3d-LICENSE`, `THIRD_PARTY_NOTICES.md`).

---

## 🇺🇸 English

Tools for [g3d](https://github.com/groverburger/g3d) 1.6.0 (LÖVE 11.4+) by **generico_cube**: real-time lighting (`g3d-cube-tools/g3d-iluminacao/`), 3D spatial audio (`g3d-cube-tools/som3d/`), an animated `.glb` loader (`g3d-cube-tools/g3d-glb/`) and UI + unified input + 3D click picking for desktop and mobile (`g3d-cube-tools/g3dui/`).

**Layout:** `g3d/` is groverburger's engine (third party). Everything by generico_cube lives inside `g3d-cube-tools/`.
**Use everything:** copy `g3d/` and `g3d-cube-tools/` into your project and `require` them as shown above.
**Use one tool:** copy `g3d/` plus `g3d-cube-tools/<tool>/` (keep the `g3d-cube-tools/` folder name).
**Demos:** run `love .` and pick one from the menu (`1`, `2`, `3`, `4`); `F10` returns to the menu. See `g3d-cube-tools/docs/` for each tool's API and controls.
**Phone testing:** the demos have touch controls (joystick = `W A S D`, drag the right half to look, `Up`/`Down` = space/shift, `Keys` = the demo's keys, `Menu` = `F10`). They turn on by themselves on a phone; on PC enable "Touch controls" in the menu to preview. Zip the folder contents (with `main.lua` at the zip root), rename it to `.love`, copy the file to your phone and open it with LÖVE for Android 11.4+. iOS is untested (LÖVE for iOS must be built with Xcode).
**Core fixes:** `camera.lookAt` axis bug, and a more robust `objloader` (negative indices, clear errors, per-triangle vertices, flat normals when missing).
