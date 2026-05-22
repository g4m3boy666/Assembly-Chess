ASM = chess.asm
OBJ = chess.o
BIN = chess

.PHONY: all run clean

all: $(BIN)

$(OBJ): $(ASM)
	nasm -f elf64 $(ASM) -o $(OBJ)

$(BIN): $(OBJ)
	ld $(OBJ) -o $(BIN)

run: $(BIN)
	./$(BIN)

clean:
	rm -f $(OBJ) $(BIN)
