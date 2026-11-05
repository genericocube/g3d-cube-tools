# FPS Mobile

Protótipo de jogo em primeira pessoa feito por **generico_cube** com as ferramentas deste repositório.

## Controles

- **Celular:** joystick no canto inferior esquerdo para andar; arraste o lado direito para olhar; botão PULAR no canto inferior direito.
- **PC:** WASD ou setas para andar; mouse/toque para olhar; Espaço para pular; Esc para pausar.
- **Gamepad:** analógico esquerdo para andar, analógico direito para olhar e A para pular.
- **F10:** voltar ao menu das demos.

## Implementação

- `g3d`: cenário 3D, câmera em primeira pessoa e cápsula de colisão do jogador.
- `g3dui`: joystick, touchpad, botão de pulo, HUD e pausa; os controles suportam multitouch.
- `g3d-iluminacao`: iluminação do cenário em preset baixo, com sombras desativadas para priorizar desempenho em celulares.
- Colisões horizontais simples entre a cápsula do jogador, obstáculos e limites da arena.
- Não há armas nesta versão.

Abra o repositório com LÖVE 11.4+ e selecione a opção **5 - FPS Mobile**. A janela está configurada em orientação paisagem.
