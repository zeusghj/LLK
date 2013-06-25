//
//  DataCenter.h
//  LLK
//
//  Created by guohongjun on 13-1-5.
//
//

#ifndef LLK_DataCenter_h
#define LLK_DataCenter_h

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdarg.h>

#define WIDTH 14  /*十四行十列*/
#define HEIGHT 10
#define NUMBER 26
#define CELL_VALUE_PATH -65

#define HAS_NEIGHBOUR 	0
#define NO_NEIGHBOUR 	1

#define NO_CONNECT 		0
#define ONE_LINE_CONNECT 	1
#define TWO_LINE_CONNECT 	2
#define THREE_LINE_CONNECT 	3
#define MAYBE_CONNECT 		4

#define SCENARIO_NORMAL 	0
#define SCENARIO_LEFT 		1
#define SCENARIO_RIGHT 		2
#define SCENARIO_UP 		3
#define SCENARIO_DOWN 		4
#define SCENARIO_LEFT_RIGHT 	5
#define SCENARIO_UP_DOWN 	6
#define SCENARIO_V_CENTRAL 	7
#define SCENARIO_H_CENTRAL 	8
#define SCENARIO_P_CENTRAL 	9

#define SCENARIO_FLAG_MARKED 	0
#define SCENARIO_FLAG_NO_MARKED 1


/*节点的数据结构，用于记录每个节点的信息*/
typedef struct _CELL_NODE {
    int value;  //决定用户看到每个节点中的内容
    
    char row;
    char column;
    int connect_flag; //连通标记，在路径搜索中用到
    int boundary_flag;  //边界标记，在路径搜索中用到
    int scenario_flag;
    struct _CELL_NODE *next;
    
}CELL_NODE;

/*节点列表的数据结构，将同value的节点串联起来，（不包含空白的节点。）*/
typedef struct _CELL_LIST {
    int count; //链表中的节点个数。
    CELL_NODE *link ;//同value的节点。
}CELL_LIST;

typedef struct _PATH {
    CELL_NODE *start;
    CELL_NODE *corner1;
    CELL_NODE *corner2;
    CELL_NODE *end;
    int connect_flag;
}PATH;


class DataCenter {
    
private:
    CELL_NODE *g_cell;
    CELL_LIST g_list[];
    
public:
    DataCenter();
    virtual ~DataCenter();
    
    void init_new_game(int scenario);
    //CELL_NODE *get_cell(int column, int row);
    
public:  //connect
    
    void init_connect_flag();
    void produce_path (CELL_NODE *start, CELL_NODE *end, CELL_NODE *corner1, CELL_NODE *corner2,PATH *path, int flag);
    int check_neighbour_status(CELL_NODE *src_cell);
    int check_0_line_connect(CELL_NODE *first, CELL_NODE *second);
    int check_1_line_connect(CELL_NODE *first, CELL_NODE *second);
    int check_2_line_connect(CELL_NODE *first, CELL_NODE *second, CELL_NODE **ret_corner);
    void mark_1_line_connect_flag(CELL_NODE *second);
    int check_3_line_connect(CELL_NODE *first, CELL_NODE *second, CELL_NODE **corner1, CELL_NODE**corner2);
    int check_connect(CELL_NODE *first, CELL_NODE *second, PATH *path);
    int  check_die(PATH *path); /*检查是否死锁*/
    
private:   // init
    
    int init_scenario(int scenario);
    int adjust_for_average(int diff);
    int adjust_for_parity();
    void init_list();
    void init_cell();
    
public:   //list
    
    int remove_from_list(CELL_NODE *cell);
    int add_to_list(CELL_NODE *cell);
    void exchange_in_list(int src_v, int dst_v);
    void reproduce_game();
    
public:   //util
    void init_rand_seed();
    
public:    //output
    void refresh_game_scene(CELL_NODE *first, CELL_NODE *second);
    
};


#define get_cell(column, row) g_cell + (WIDTH+2)*(row) + (column)

typedef struct _PERF
{
    time_t start_time;
    time_t end_time;
}PERF;


#endif
