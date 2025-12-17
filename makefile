CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -g -w
TARGET = sysy

.PHONY: all clean run

all: $(TARGET)

$(TARGET): sysy.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $(TARGET) sysy.tab.c lex.yy.c -lfl

sysy.tab.c sysy.tab.h: sysy.y
	$(BISON) -d sysy.y

lex.yy.c: sysy.l sysy.tab.h
	$(FLEX) sysy.l

clean:
	rm -f $(TARGET) lex.yy.c sysy.tab.c sysy.tab.h

run: $(TARGET)
	./$(TARGET) $(FILE)