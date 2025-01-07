"""
Generate a QR code for the specified URL

Install:
```
conda create -n qrcodes
conda activate qrcodes
pip3 install PyQRCodeNG pypng
```

Usage:
conda activate qrcodes
python generate_qr_code.py -url https://www.example.com -o /path/to/output.png

"""


import argparse
import pyqrcodeng


def generate_qr(url: str, output_filename: str):
    """Generate a QR code for the specified URL.

    Tries to create the QR code with version=8, and if that fails,
    retries with version=10. Finally saves it as a PNG.
    Args:
        url (str): The URL to encode in the QR code.
        output_filename (str): The path (including filename) to save the QR code PNG.
    """
    try:
        qr = pyqrcodeng.create(url, version=8)
    except ValueError:
        qr = pyqrcodeng.create(url, version=10)
    qr.png(output_filename, scale=10)
    print(f"QR code generated: {output_filename}")

def main():
    parser = argparse.ArgumentParser(description="Generate a QR code from a URL.")
    parser.add_argument("-url",
                        help="The URL to encode in the QR code. Example: https://www.example.com",
                        required=True)
    parser.add_argument("-o",
                        help="Path (including filename) to save the QR code PNG. Example: /path/to/output.png",
                        required=True)
    args = parser.parse_args()
    generate_qr(args.url, args.o)

if __name__ == "__main__":
    main()
