#include <stdio.h>
#include <stdlib.h>
#include "rose.tab.h"
#include "tree.h"
static int t = 0;
static int L = 0;
void getReg()
{
    if (t < 10)
    {
        t++;
    }
}
void putReg()
{
    if (t > 0)
    {
        t--;
    }
}
void ini_Reg()
{
    t = 0;
}
void newLabel()
{
    L++;
}
void gen_code_data(struct tree_node *n)
{
    switch (n->type)
    {
    case DLIST:
        gen_code_data(n->left);
        gen_code_data(n->right);
        printf(":  .word 0\n");
        break;
    case ID:
        printf("%s", n->name);
        break;
    case NIL:
        printf("");
        break;
    default:
        fprintf(stderr, "semantic error\n");
        break;
    }
}
void gen_code(struct tree_node *n)
{
    static int tempL=0;
    switch (n->type)
    {
    case CONST:
        printf("\n    li   $t%d, %d", t, n->val);
        getReg();
        break;
    case ID:
        printf("\n    la   $t%d, %s", t, n->name);
        printf("\n    lw   $t%d, 0($t%d)", t, t);
        getReg();
        break;
    case MINUS:
        gen_code(n->unary);
        putReg();
        printf("\n    neg  $t%d, $t%d", t, t);
        getReg();
        break;
    case ADD:
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    add  $t%d, $t%d, $t%d", t-1, t-1, t);

        break;
    case SUB:
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    sub  $t%d, $t%d, $t%d", t-1, t-1, t);

        break;
    case MUL:
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    mul  $t%d, $t%d, $t%d", t-1, t-1, t);

        break;
    case DIV:
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    div  $t%d, $t%d, $t%d", t-1, t-1, t);

        break;
    case MOD:
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    rem  $t%d, $t%d, $t%d", t-1, t-1, t);

        break;
    case EQ:
        // printf("\n    (== ");
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    beq  $t%d, $t%d, L%d", t - 1, t, L);
        

        break;
    case NE:
        // printf("\n    (<> ");
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    bne  $t%d, $t%d, L%d", t - 1, t, L);

        break;
    case GT:
        // printf("\n    (> ");
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    bgt  $t%d, $t%d, L%d", t - 1, t, L);

        break;
    case GE:
        // printf("\n    (>= ");
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    bge  $t%d, $t%d, L%d", t - 1, t, L);

        break;
    case LT:
        // printf("\n    (< ");
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    blt  $t%d, $t%d, L%d", t - 1, t, L);

        break;
    case LE:
        // printf("\n    (<= ");
        gen_code(n->left);
        gen_code(n->right);
        putReg();
        printf("\n    ble  $t%d, $t%d, L%d", t - 1, t, L);

        break;
    case AND:
        // printf("\n    (&& ");
        gen_code(n->left);
        gen_code(n->right);
        printf("\n    and  $t%d, $t%d, $t%d", t - 1, t - 1, t);
        putReg();

        break;
    case OR:
        // printf("\n    (|| ");
        gen_code(n->left);
        gen_code(n->right);
        printf("\n    or   $t%d, $t%d, $t%d", t - 1, t - 1, t);
        putReg();

        break;
    case NOT:
        // printf("\n    (! ");
        gen_code(n->unary);
        printf("\n    nor  $t%d, $t%d, $t%d", t - 1, t - 1, t);
        putReg();

        break;
    case ASSIGN:
        gen_code(n->unary);
        printf("\n    la   $t%d, %s", t, n->name);
        printf("\n    sw   $t%d, 0($t%d)", t - 1, t);
        putReg();
        break;
    // case READ: printf("(read "); printf("%s", n->name); printf(")"); break;
    case READ:
        printf("\n    li   $v0, 5\n    syscall\n    la   $t%d, %s\n    sw   $v0, 0($t%d)", t, n->name, t);
        putReg();
        break;
    case WRITE:
        gen_code(n->unary);
        putReg();
        printf("\n    move $a0, $t%d\n    li   $v0, 1\n    syscall", t);

        break;
    case EXIT:
        printf("\n    li   $v0, 10\n    syscall");
        break;
    // case NIL: printf("()"); break;
    case NIL:
        printf("");
        break;
    case LPA:
        printf("");
        gen_code(n->left);
        break;
    case SLIST:
        printf("");
        gen_code(n->left);
        printf("");
        gen_code(n->right);
        break;
    case IFTHEN:
        // printf("\n    (if   then ");
        tempL= L;
        newLabel();
        newLabel();

        gen_code(n->unary);
        printf("\n    b    L%d", tempL+2);
        ini_Reg();
        printf("\nL%d: #then", tempL+1);
        gen_code(n->left);
        ini_Reg();
        printf("\nL%d: #end if",L);
        break;
    case IFTHENELSE:
        // printf("\n    (if     then    else ");
        tempL = L;
        newLabel();
        newLabel();
        newLabel();

        gen_code(n->unary);
        printf("\n    b    L%d", tempL+2);

        ini_Reg();
        printf("\nL%d: #then", tempL+1);
        gen_code(n->left);
        printf("\n    b    L%d", tempL+3);

        ini_Reg();
        printf("\nL%d: #else",tempL+2);
        gen_code(n->right);

        ini_Reg();
        printf("\nL%d: #end if",tempL+3);
        break;
    case FOR:
        // printf("\n    (for ");
        tempL= L;
        newLabel();
        newLabel();
        newLabel();
        gen_code(n->left);
        printf("\n    la   $t%d, %s", t,n->name);
        putReg();
        printf("\n    sw   $t%d, 0($t%d)",t,t+1);
        ini_Reg();
        printf("\nL%d: #for",tempL+1);
        printf("\n    la   $t%d, %s", t,n->name);
        printf("\n    lw   $t%d, 0($t%d)",t,t);
        getReg();
        gen_code(n->right);
        putReg();
        putReg();
        printf("\n    ble  $t%d, $t%d, L%d", t,t+1,tempL+2);
        printf("\n    b    L%d",tempL+3);

        ini_Reg();
        printf("\nL%d: #loop",tempL+2);
        gen_code(n->unary);
        printf("\n    la   $t%d, %s", t, n->name);
        printf("\n    lw   $t%d, 0($t%d)", t, t);
        printf("\n    li   $t%d, 1", t+1);
        printf("\n    add  $t%d, $t%d, $t%d", t , t , t+1);
        printf("\n    la   $t%d, %s", t+1, n->name);
        printf("\n    sw   $t%d, 0($t%d)",t,t+1);
        printf("\n    b    L%d",tempL+1);

        ini_Reg();
        printf("\nL%d: #end loop",tempL+3);
        break;
    // case DLIST: printf("("); gen_code(n->left); printf(" "); gen_code(n->right); printf(")"); break;
    case DLIST:
        gen_code_data(n->left);
        gen_code_data(n->right);
        printf(":  .word 0\n");
        break;
    case PROCEDURE:
        printf("    .data\n");
        gen_code(n->left);

        printf("    .text\nmain:");
        gen_code(n->right);

        break;
    default:
        fprintf(stderr, "semantic error\n");
        break;
    }
}
