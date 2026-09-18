# S8 终端（kitty）

装包：`kitty`。
配置：`configs/kitty/`（`include ./theme.conf`；`theme.conf → other-themes/Nord.conf`；
`font_size 12.0`）。
流程：`stages/S8-terminal/apply.sh`（设 `x-terminal-emulator` → kitty，i3 快捷键用 kitty）。
验证：`verify.sh`（版本、默认终端、配置解析）。
