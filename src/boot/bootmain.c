#include <types.h>
#include <x86.h>
#include <elf.h>

// #define COM1            0x3F8
// #define COM_TX          0           // Out: Transmit buffer (DLAB=0)
// #define COM_LSR         5           // In:  Line Status Register
// #define COM_LSR_TXRDY   20          // Transmit buffer avail

#define LPTPORT         0x378
#define CRTPORT         0x3D4
#define SECTSIZE        512
#define ELFHDR          ((struct elfhdr *)0x10000)  // scratch space

static uint16_t *crt = (uint16_t *) 0xB8000;        // CGA memory

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
        delay();
    }
    outb(LPTPORT + 0, c);
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}

/* cga_putc - print character to console */
static void
cga_putc(int c) {
    int pos;

    // cursor position: col + 80*row.
    outb(CRTPORT, 14);
    pos = inb(CRTPORT + 1) << 8;
    outb(CRTPORT, 15);
    pos |= inb(CRTPORT + 1);

    if (c == '\n') {
        pos += 80 - pos % 80;
    }
    else {
        crt[pos ++] = (c & 0xff) | 0x0700;
    }

    outb(CRTPORT, 14);
    outb(CRTPORT + 1, pos >> 8);
    outb(CRTPORT, 15);
    outb(CRTPORT + 1, pos);
}

/* serial_putc - copy console output to serial port */
// static void
// serial_putc(int c) {
//     int i;
//     for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
//         delay();
//     }
//     outb(COM1 + COM_TX, c);
// }

/* cons_putc - print a single character to console*/
static void
cons_putc(int c) {
    lpt_putc(c);
    cga_putc(c);
    // serial_putc(c);
}

/* cons_puts - print a string to console */
// static void
// cons_puts(const char *str) {
//     while (*str != '\0') {
//         cons_putc(*str ++);
//     }
// }

static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40);
}

static void
readsect(void *dst, uint32_t secno) {
    waitdisk();

    outb(0x1F2, 1);                             // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                          // cmd 0x20 - read sectors

    waitdisk();

    insl(0x1F0, dst, SECTSIZE / 4);
}

static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    uint32_t secno = (offset / SECTSIZE) + 1;

    for (; va < end_va; va += SECTSIZE, secno++)
        readsect((void*)(va), secno);
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // cons_puts("This is a bootloader: Hello world!!");
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    if (ELFHDR->e_magic != ELF_MAGIC) goto bad;

    cons_putc('B');
    while (1);

bad:
    cons_putc('E');
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);
    /* do nothing */
    while (1);
}

