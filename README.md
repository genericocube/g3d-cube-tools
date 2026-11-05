# g3d-cube-tools

**🇧🇷 Português** · **🇺🇸 English** (below)

Coleção de ferramentas para o [g3d](https://github.com/groverburger/g3d) 1.6.0 (LÖVE 11.4+), feitas por **generico_cube**:

| Ferramenta | O que faz | Onde fica | Docs |
|---|---|---|---|
| **g3d-iluminacao** | Luz em tempo real: sol com sombras, luzes de ponto, spot e direcional, neblina, toon, presets de qualidade | `g3d-iluminacao/` | [docs/iluminacao.md](docs/iluminacao.md) |
| **som3d** | Áudio espacial 3D (distância, Doppler, filtros, reverb) | `som3d.lua` | [docs/som3d.md](docs/som3d.md) |
| **g3d-glb** | Carrega `.glb` com cores, texturas e animações de esqueleto | `g3d/glb.lua` | [docs/glb.md](docs/glb.md) |
| **g3d-interface-e-entrada** | Interface (botão, joystick, touchpad, slider, texto...), entrada unificada (teclado, mouse, toque, gamepad) e clique em objetos 3D. PC e celular | `g3dui/` | [docs/interface.md](docs/interface.md) |

## Como usar tudo

Baixe este repositório e copie para o seu projeto: `g3d/`, `g3d-iluminacao/`, `g3dui/` e `som3d.lua`.

```lua
local g3d = require "g3d"
local glb = require "g3d.glb"
local som3d = require "som3d"
local Lighting = require "g3d-iluminacao"
local ui = require "g3dui"
```

## Como usar só uma ferramenta

Todas dependem apenas da pasta `g3d/`.

- **g3d-iluminacao**: `g3d/` + `g3d-iluminacao/`
- **som3d**: `g3d/` + `som3d.lua`
- **g3d-interface-e-entrada**: `g3d/` + `g3dui/` (o `g3d/` só é necessário para clicar em objetos 3D)
- **g3d-glb**: só a pasta `g3d/` (o `glb.lua` já está dentro dela)

## Demos

Rode a raiz com LÖVE (`love .`) e escolha no menu (teclado, mouse ou toque): `1` iluminação, `2` som3d, `3` glb, `4` interface e entrada, `5` FPS Mobile.
`F10` dentro de uma demo volta ao menu. Os controles de cada ferramenta estão nos docs.
A demo FPS Mobile usa joystick, touchpad, botão de pulo, cápsula de colisão e iluminação em preset baixo: [docs/fps-mobile.md](docs/fps-mobile.md).
As demos ficam em `demos/` e podem ser apagadas sem afetar as ferramentas.

## Testar no celular

As demos funcionam com **controles de toque**. No FPS Mobile, o joystick fica à esquerda, o arrasto da câmera à direita e o botão de pulo no canto inferior direito. A orientação da janela está configurada como paisagem.

1. Instale o LÖVE no celular (Android: [love2d.org](https://love2d.org), versão 11.4 ou mais nova).
2. Compacte o **conteúdo** da pasta (não a pasta em si) em um `.zip` e renomeie para `.love`. O `main.lua` precisa ficar na **raiz** do zip.
3. Copie o arquivo para o celular e abra com o LÖVE.

O iOS não foi testado: o LÖVE para iOS precisa ser compilado com o Xcode.

## Mudanças no núcleo g3d

O núcleo é o mesmo nos três projetos originais. Aqui há duas correções pequenas:

- `camera.lookAt` calculava direção/pitch com os eixos errados (z é o eixo vertical), o que fazia a câmera pular ao olhar com o mouse depois de um `lookAt`.
- `objloader`: aceita índices negativos do `.obj`, dá erro claro para índices inexistentes, não reaproveita o mesmo vértice entre triângulos de quads e gera normal plana para faces sem normais.

## Licença

MIT (veja `LICENSE`). O g3d é de groverburger, também MIT (`g3d-LICENSE`, `THIRD_PARTY_NOTICES.md`).

---

## 🇺🇸 English

Tools for [g3d](https://github.com/groverburger/g3d) 1.6.0 (LÖVE 11.4+) by **generico_cube**: real-time lighting, 3D spatial audio, an animated `.glb` loader, and UI + unified input for desktop and mobile.

**Demos:** run `love .` and pick one from the menu (`1` lighting, `2` som3d, `3` glb, `4` interface, `5` FPS Mobile). Press `F10` inside a demo to return to the menu.
**FPS Mobile:** first-person movement, mobile joystick, touch camera look, jump button, capsule collision body, arena obstacles and low-cost lighting. See [docs/fps-mobile.md](docs/fps-mobile.md).
**Phone testing:** zip the folder contents (with `main.lua` at the zip root), rename it to `.love`, copy it to your phone and open it with LÖVE for Android 11.4+.
**Core fixes:** `camera.lookAt` axis bug, and a more robust `objloader`.

