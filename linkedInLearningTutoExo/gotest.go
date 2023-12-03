///usr/bin/true; exec /usr/bin/env go run "$0" "$@"

package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Printf("All program's arguments: %#v", os.Args)
	fmt.Println()
	fmt.Println("Hello world!")
}
