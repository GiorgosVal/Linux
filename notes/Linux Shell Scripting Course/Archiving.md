# Archiving
## The `tar` command
### What is a Tape ARchive
Tar (for "Tape ARchive") is an archiving program that **creates a single file** called an "archive" from a number of specified files or **extracts the files** from such an archive, while **preserving file system information such as permissions, dates, etc**. A tar archive has the file suffix ".tar". The files in a tar archive **are not compressed**, just gathered together in one file.

### Usage
Read `man tar` (short manual) or `info tar` (complete manual).

`tar [OPTION...] [FILE]...`

Examples:

```bash
tar -cf /path/archive.tar fooFile barFile fooDir barDir
    # Create (-c) archive.tar (-f) int the path from files fooFile, barFile and directories fooDir, barDir.

tar -tvf /path/archive.tar
    # List all files (-t) in archive.tar (-f) found in the path verbosely (-v).

tar -xf archive.tar -C /path/to/extract/to
    # Extract (-x) all files from archive.tar (-f) to the path specified (-C - if omitted it will be extracted in the current location)
```

# Compressing
## With `gzip`
To compress tarballs:
```bash
# Compress
gzip archive.tar

# Decompress
gunzip archive.tar.gz
```

## With `bzip2`
```bash
# Compress
bzip2 archive.tar

# Decompress
bzip2 -d archive.tar.bz2
```
## With `xz`
```bash
# Compress
xz archive.tar

# Decompress
unxz archive.tar.xz
```

## Archiving and Compressing in one command
We can use `tar` and
- `-z` option we can archive and compress (or decompress) files in `.gz` or `.tgz`
- `-j` to filter the archive through `bzip2`
- `-J` to filter the archive through `xz`

Examples:
```bash
tar -vczf archive.tar.gz fooFile barFile fooDir barDir
    # Create (-c) the compressed (-z) archive.tar.gz (-f) from files fooFile, barFile and directories fooDir, barDir verbosely (-v).

tar -vtzf archive.tar.gz
    # List all files (-t) in the compressed (-z) archive.tar.gz (-f) verbosely (-v).

tar -vxzf archive.tar.gz
    # Decompress (-z) and extract (-x) all files from the archive.tar.gz (-f) verbosely (-v).
```