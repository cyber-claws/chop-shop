# chop-shop

# Usage
```bash
$ chop-shop -dlf [option] -rh


please ensure you have the latest version of:
0) ffmpeg
1) sox
2) ffprobe
3) lame


Options:

h - Print this help menu.
l - Length in seconds of each choped or padded sound sample. Default 10 seconds
d - Directory will the with audio files to be chopped or padded.
f - The file extention of the files your are padding or chopping, default is wav
r - Remove original file
```

## Example 

```bash

$ git clone https://github.com/cyber-claws/chop-shop.git && cd $_
$ sudo chmod 777 bin.sh
$ ./bin.sh -d /home/user/Desktop/audio -l 20 -f wav -r


$ # for help 
$ ./bin.sh -h

```
