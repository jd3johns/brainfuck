/*
 * Brainf**k has loop constructs ([]) which enter if the current
 * cell is non-zero, and step over the enclosing code if the
 * current cell is zero. The closing brace jumps to the open
 * brace to check the loop condition.
 *
 * Since you will lose your pointer location if the pointer
 * shifts to a different cell upon loop exit, it's vital
 * that the number of left shifts in the loop equals the
 * number of right shifts in the loop so we return to the
 * loop entrance pointer.
 *
 * This program uses a stack object to keep track of left/right
 * shifts within each brace pair.
 *
 * Author: Jonathan Johnston
 * Date:   2017/7/11
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

typedef struct bf_brace_node bf_brace_node;
struct bf_brace_node {
    bf_brace_node *next;

    int line;
    int index;
    int cell_shift_count;
};

static int push_brace_node(bf_brace_node **top)
{
    static int count = 0;
    bf_brace_node *node = (bf_brace_node*)malloc(sizeof(bf_brace_node));
    if (!node) {
        return -1;
    }

    if (*top) node->index = 1 + (*top)->index;
    else node->index = 1;

    node->index = ++count;
    node->cell_shift_count = 0;
    node->next = *top;
    *top = node;
    return 0;
}

static bf_brace_node* pop_brace_node(bf_brace_node **top)
{
    bf_brace_node *curr = *top;
    bf_brace_node *next = (*top)->next;
    curr->next = NULL;
    *top = next;

    return curr;
}

static void dealloc_stack(bf_brace_node **top)
{
    if (!*top) return;

    bf_brace_node *curr = *top;
    bf_brace_node *next;

    do {
        next = curr->next;
        free(curr);
    } while (curr = next);
}

int main(int argc, char *argv[])
{
    FILE *fp = NULL;
    int ret = 0;
    int c = 0;
    int line_number = 1;
    bf_brace_node *top = NULL;

    if (argc < 2)
    {
        fprintf(stderr, "Error: no file given\n");
        ret = -1;
        goto error;
    }

    if (!(fp = fopen(argv[1], "r"))) {
        perror(argv[1]);
        ret = errno;
        goto error;
    }

    while ((c = fgetc(fp)) != EOF) {
        if (strcmp(&c, "[") == 0) {
            if (push_brace_node(&top) != 0) {
                fprintf(stderr, "Error: cannot allocate memory\n");
                ret = ENOMEM;
                goto error;
            }

            top->line = line_number;
        }
        else if (strcmp(&c, "]") == 0) {
            if (!top) {
                fprintf(stderr, "Error: no matching open brace (line %d)\n", line_number);
                ret = -1;
                goto error;
            }

            bf_brace_node *node = pop_brace_node(&top);
            if (node->cell_shift_count != 0) {
                printf("Imbalance in loop %d (line %d): %d extra %s shift%s\n",
                        node->index, node->line,
                        node->cell_shift_count,
                        node->cell_shift_count > 0 ? "right" : "left",
                        abs(node->cell_shift_count) > 1 ? "s" : "");
            }
            free(node);
        }
        else if (strcmp(&c, ">") == 0) {
            if (top) top->cell_shift_count++;
        }
        else if (strcmp(&c, "<") == 0) {
            if (top) top->cell_shift_count--;
        }
        else if (strcmp(&c, "\n") == 0) {
            line_number++;
        }
        else {
            continue;
        }
    }

error:
    dealloc_stack(&top);
    if (fp)
    {
        fclose(fp);
    }

    return ret;
}
