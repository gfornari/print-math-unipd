# print-math-unipd
A tool to easily print PDFs in the Math labs of the University of Padua.

## Usage
Make sure it's executable:

```
chmod +x print-math-unipd.sh
```

Then just run it providing some PDF files, like:

```
./print-math-unipd.sh *.pdf
```

It supports any scheme of pages supported by `pdfjam`.

For all supported options, run `./print-math-unipd.sh --help`.

## Clarification on the pages scheme
Suppose you have a PDF with some pages (1, 2, 3, 4, ...), each side is
identified with A and B, and an upside down page is indicated as 1ud (and the
other pages correspondingly).

The `2x1` option means:

```
      A               B
|-----|-----|   |-----|-----|
|     |     |   |     |     |
|  1  |  2  |   | 3ud | 4ud |
|     |     |   |     |     |
|-----|-----|   |-----|-----|
```

The `1x2` option means:

```
      A               B
|-----------|   |-----------|
|     1     |   |    3ud    |
|-----------|   |-----------|
|     2     |   |    4ud    |
|-----------|   |-----------|
```

The `2x2` option means:

```
      A               B
|-----|-----|   |-----|-----|
|  1  |  2  |   | 5ud | 6ud |
|-----|-----|   |-----|-----|
|  3  |  4  |   | 7ud | 8ud |
|-----|-----|   |-----|-----|
```

## Notes
* It creates a new folder `print-ready` in the current directory.
* It tries to parallelise the processing using the maximum number of cores.

## Till the infinity and beyond (aka TODO)
* Partition PDFs of max 20 pages or size of 60MB, whichever is less in size.
* Send generated PDFs to the printer.
* Make it more flexible w.r.t. the `pdfjam` options (just pass them as they
  are?).
