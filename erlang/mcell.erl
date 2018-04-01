- module(mcell) .
- export([main/0]) .

% UTILS
sleep(Time) -> receive after Time * 10 -> ok end .

main() -> 
    sleep(10)
.