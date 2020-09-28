# EAC Tools

*"Making Easy Anti-Cheat work in Wine one ragequit at a time."*

A little something to help figure out the games and platforms EAC serves binary blobs for on their CDN.

## Usage

Download the 64-bit Wine binary blob for game ID 55 (implicit `--os-type=wine64`):

    $ ./download.sh --id=55

Download win64 binary blobs for game IDs beginning from 1 up to and including 550:

    $ ./download.sh --os-type=win64 --from-id=1 --to-id=550

Confirmed valid `--os-type` values are `win32`, `win64`, `wow64`, `wine32`, and `wine64`. Others may also exist.

### Fun things to try

* Scrape wine64 binary blob downloads for game IDs 20 to 50 (inclusive):

        $ ./download.sh --os-type=wine64 --from-id=20 --to-id=50
         game id         dl size        last modified (UTC)     download saved as
         -------         -------        -------------------     -----------------
              21          218624        2019-04-11 13:04:43     eac-game-021-wine64.bin
              36          242688        2019-04-11 12:52:23     eac-game-036-wine64.bin
              43               0        2020-06-18 09:38:26
              45               0        2019-11-13 11:39:44
              49               0        2019-07-08 10:54:32

* Try the same with `--os-type=win64` to realize how badly EAC neglects Wine:

        $ ./download.sh --os-type=win64 --from-id=20 --to-id=50
         game id         dl size        last modified (UTC)     download saved as
         -------         -------        -------------------     -----------------
              20         3543680        2020-06-09 08:27:24     eac-game-20-win64.bin
              21         3503232        2020-06-08 10:00:17     eac-game-21-win64.bin
              24          770320        2019-04-11 12:56:41     eac-game-24-win64.bin
              28         1616512        2019-09-25 08:41:30     eac-game-28-win64.bin
              29         3481728        2020-07-31 13:31:58     eac-game-29-win64.bin
              32          728848        2019-04-11 12:56:50     eac-game-32-win64.bin
              35         2501744        2019-08-13 13:33:24     eac-game-35-win64.bin
              36         3494528        2020-07-31 13:52:46     eac-game-36-win64.bin
              37         2412656        2019-08-27 14:49:04     eac-game-37-win64.bin
              38          782608        2019-04-11 13:00:46     eac-game-38-win64.bin
              39          806672        2019-04-11 13:07:30     eac-game-39-win64.bin
              40          708368        2019-04-11 13:10:37     eac-game-40-win64.bin
              42          740624        2019-04-11 13:09:47     eac-game-42-win64.bin
              43         2963072        2020-06-25 11:40:10     eac-game-43-win64.bin
              45         2926720        2020-06-09 14:13:15     eac-game-45-win64.bin
              46         1523240        2019-04-11 13:07:54     eac-game-46-win64.bin
              47         1722496        2019-04-11 13:00:51     eac-game-47-win64.bin
              48         3492480        2020-06-09 07:45:46     eac-game-48-win64.bin
              49         2491504        2019-08-13 13:34:14     eac-game-49-win64.bin
