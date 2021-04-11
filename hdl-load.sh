#!/bin/sh

upload_iso()
{
	DEVICE="$1"
	ISO="$2"
	NAME="$(basename -s .iso "$ISO")"
	DISC_ID=$(hdl_dump cdvd_info "$ISO" | cut -d " " -f 1)
	DISC_ID=$(eval echo $DISC_ID)

	# echo iso: $ISO
	# echo name: $NAME
	# echo disc_id: $DISC_ID
	echo "Uploading '$NAME'"
	hdl_dump inject_dvd "$DEVICE" "$NAME" "$ISO" "$DISC_ID"
	echo
}

usage()
{
	echo "Usage: $(basename $0) /dev/sdX [iso filename...]"
	echo
	echo "List games:"
	echo "        hdl_dump toc /dev/sdX"
	echo "Print ISO info:"
	echo "        hdl_dump cdvd_info image.iso"
}

if [ "$1" = "-h" -o "$1" = "--help" ]; then
        usage
        exit 0
elif [ $# == 0 ]; then
        echo "No hard disk specified" >&2
        usage
        exit 1
elif [ $# == 1 ]; then
        echo "No ISO to upload specified" >&2
        usage
        exit 1
fi

type hdl_dump >/dev/null 2>/dev/null || {
        echo "hdl_dump not found" >&2
        exit 1
}

DEVICE="$1"
shift
if ! [ -b "$DEVICE" ]; then
        echo "Invalid hard disk specified" >&2
        usage
        exit 1
fi

if [ -f info.sys ]; then
        echo "Remove stray info.sys file" >&2
        exit 1
fi

while [ $# -gt 0 ]; do
        ISO="$1"
        shift

        upload_iso "$DEVICE" "$ISO"
done
