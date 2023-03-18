struct tree_node
{
    int type;
    char* name;
    int val;
    struct tree_node* left;
    struct tree_node* right;
    struct tree_node* unary;
};

struct tree_node* build_id(char* name);
struct tree_node* build_const(int val);
