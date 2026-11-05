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

Rode a raiz com LÖVE (`love .`) e escolha no menu: `1` iluminação, `2` som3d, `3` glb, `4` interface e entrada.
`F10` dentro de uma demo volta ao menu. Os controles de cada demo estão nos docs de cada ferramenta.
As demos ficam em `demos/` e podem ser apagadas sem afetar as ferramentas.

## Mudanças no núcleo g3d

O núcleo é o mesmo nos três projetos originais. Aqui há duas correções pequenas:

- `camera.lookAt` calculava direção/pitch com os eixos errados (z é o eixo vertical), o que fazia a câmera pular ao olhar com o mouse depois de um `lookAt`.
- `objloader`: aceita índices negativos do `.obj`, dá erro claro para índices inexistentes, não reaproveita o mesmo vértice entre triângulos de quads e gera normal plana para faces sem normais.

## Licença

MIT (veja `LICENSE`). O g3d é de groverburger, também MIT (`g3d-LICENSE`, `THIRD_PARTY_NOTICES.md`).

---

## 🇺🇸 English

Tools for [g3d](https://github.com/groverburger/g3d) 1.6.0 (LÖVE 11.4+) by **generico_cube**: real-time lighting (sun with shadows, point / spot / directional lights, fog, toon, quality presets) (`g3d-iluminacao/`), 3D spatial audio (`som3d.lua`), an animated `.glb` loader (`g3d/glb.lua`) and UI + unified input + 3D click picking for desktop and mobile (`g3dui/`, docs in `docs/interface.md`).

**Use everything:** copy `g3d/`, `g3d-iluminacao/`, `g3dui/` and `som3d.lua` into your project and `require` them as shown above.
**Use one tool:** copy `g3d/` plus that tool's file/folder (`g3d-glb` is already inside `g3d/`).
**Demos:** run `love .` and pick one from the menu (`1`, `2`, `3`, `4`); `F10` returns to the menu. See `docs/` for each tool's API and controls.
**Core fixes:** `camera.lookAt` axis bug, and a more robust `objloader` (negative indices, clear errors, per-triangle vertices, flat normals when missing).
