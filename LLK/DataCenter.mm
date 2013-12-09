//
//  DataCenter.cpp
//  LLK
//
//  Created by guohongjun on 13-1-5.
//
//

#include "DataCenter.h"


DataCenter::DataCenter()  //构造函数
{
}

DataCenter::~DataCenter()  //析构函数
{
}

void DataCenter::init_new_game(int scenario)
{
    printf("init_new_game");
//    init_list();
//	init_cell();
//    
//	adjust_for_average(2);
//	adjust_for_parity();
//	
//	init_scenario(scenario);
}

#pragma mark - connect 

void DataCenter::init_connect_flag()
{
    int i, j;
	CELL_NODE *temp_cell;
    
	for(i=0;i<HEIGHT+2;i++)
	{
		for(j=0;j<WIDTH+2;j++)
		{
			temp_cell = get_cell(j, i);
			temp_cell->connect_flag = NO_CONNECT;
		}
	}
}

void DataCenter::produce_path(CELL_NODE *start, CELL_NODE *end, CELL_NODE *corner1, CELL_NODE *corner2, PATH *path, int flag)
{
    path->connect_flag = flag;
	path->start = start;
	path->end   = end;
	path->corner1 = corner1;
	path->corner2 = corner2;
}

int DataCenter::check_neighbour_status(CELL_NODE *src_cell)
{
    CELL_NODE *temp_cell;
    
	temp_cell = src_cell+1;
	if(temp_cell->value == CELL_VALUE_PATH)
		return NO_NEIGHBOUR;
    
	temp_cell = src_cell-1;
	if(temp_cell->value == CELL_VALUE_PATH)
		return NO_NEIGHBOUR;
    
	temp_cell = src_cell+(WIDTH+2);
	if(temp_cell->value == CELL_VALUE_PATH)
		return NO_NEIGHBOUR;
    
	temp_cell = src_cell-(WIDTH+2);
	if(temp_cell->value == CELL_VALUE_PATH)
		return NO_NEIGHBOUR;
    
	return HAS_NEIGHBOUR;
}

int DataCenter::check_0_line_connect(CELL_NODE *first, CELL_NODE *second)
{
    char column1, row1;
	char column2, row2;
    
	if(first==second)
		return NO_CONNECT;
    
	if(first->value == CELL_VALUE_PATH || second->value == CELL_VALUE_PATH)
		return NO_CONNECT;
    
	if(first->value != second->value)
		return NO_CONNECT;
    
    
	column1 = first->column;
	row1    = first->row;
	column2 = second->column;
	row2    = second->row;
    
	if((abs(row1-row2)+abs(column1-column2)) > 1)
	{
		if(check_neighbour_status(first)==HAS_NEIGHBOUR)
			return NO_CONNECT;
        
		if(check_neighbour_status(second)==HAS_NEIGHBOUR)
			return NO_CONNECT;
	}
	return MAYBE_CONNECT;
}

int DataCenter::check_1_line_connect(CELL_NODE *first, CELL_NODE *second)
{
    int column1 = first->column;
	int row1    = first->row;
	int column2 = second->column;
	int row2    = second->row;
    
	int step;
	CELL_NODE *temp;
    
    
    if(row1 == row2)
		step = column2>column1?1:-1;
	else if(column1 == column2)
		step= row2>row1?(WIDTH+2):-(WIDTH+2);
	else
		return MAYBE_CONNECT;
	
	temp = first + step;
	while(temp != second)
	{
		if(temp->value != CELL_VALUE_PATH)
			return MAYBE_CONNECT;
        
		temp = temp + step;
	}
    
	return ONE_LINE_CONNECT;
}

int DataCenter::check_2_line_connect(CELL_NODE *first, CELL_NODE *second, CELL_NODE **ret_corner)
{
    CELL_NODE *corner;
    
	if(first->column == second->column)
		return MAYBE_CONNECT;
    
	if(first->row == second->row)
		return MAYBE_CONNECT;
    
	corner = get_cell(first->column, second->row);
	if(corner->value==CELL_VALUE_PATH)
	{
		if(check_1_line_connect(first, corner)==ONE_LINE_CONNECT && check_1_line_connect(second, corner)==ONE_LINE_CONNECT)
		{
			*ret_corner = corner;
			return TWO_LINE_CONNECT;
		}
	}
	
	corner = get_cell(second->column, first->row);
	if(corner->value==CELL_VALUE_PATH)
	{
		if(check_1_line_connect(first, corner)==ONE_LINE_CONNECT && check_1_line_connect(second, corner)==ONE_LINE_CONNECT)
		{
			*ret_corner = corner;
			return TWO_LINE_CONNECT;
		}
	}
	return MAYBE_CONNECT;
}

void DataCenter::mark_1_line_connect_flag(CELL_NODE *second)
{
    CELL_NODE *temp;
	int step;
	int i;
    
	for(i=0;i<4;i++)
	{
		switch(i)
		{
			case 0:
				step = -1;
				break;
			case 1:
				step = 1;
				break;
			case 2:
				step = (WIDTH+2);
				break;
			case 3:
				step = -(WIDTH+2);
				break;
		}
        
		temp = second + step;
		while(temp->value == CELL_VALUE_PATH)
		{
			temp->connect_flag = ONE_LINE_CONNECT;
			if(temp->boundary_flag == 1)
				break;
			temp = temp + step;
		}
	}
}

int DataCenter::check_3_line_connect(CELL_NODE *first, CELL_NODE *second, CELL_NODE **corner1, CELL_NODE **corner2)
{
    CELL_NODE *temp_cell_1,  *temp_cell_2;
	int row1, column1;
	int row2, column2;
	int row,  column;
    
	init_connect_flag();
	mark_1_line_connect_flag(first);
	mark_1_line_connect_flag(second);
	
	row1=first->row;
	row2=second->row;
	if(row1 != row2)
	{
		for(column=0;column<WIDTH+2;column++)
		{
			temp_cell_1 = get_cell(column, row1);
			if(temp_cell_1->connect_flag != ONE_LINE_CONNECT)
				continue;
            
			temp_cell_2 = get_cell(column, row2);
			if(temp_cell_2->connect_flag != ONE_LINE_CONNECT)
				continue;
            
			if(check_1_line_connect(temp_cell_1, temp_cell_2)==ONE_LINE_CONNECT)
                goto CHECK_3_SUCCESS_RET;
		}
	}
    
	column1=first->column;
	column2=second->column;
 	if(column1 != column2)
	{
		for(row=0;row<HEIGHT+2;row++)
		{
			temp_cell_1 = get_cell(column1, row);
			if(temp_cell_1->connect_flag != ONE_LINE_CONNECT)
				continue;
            
			temp_cell_2 = get_cell(column2, row);
			if(temp_cell_2->connect_flag != ONE_LINE_CONNECT)
				continue;
            
			if(check_1_line_connect(temp_cell_1, temp_cell_2)==ONE_LINE_CONNECT)
                goto CHECK_3_SUCCESS_RET;
		}
	}
	return NO_CONNECT;
    
CHECK_3_SUCCESS_RET:
	*corner1 = temp_cell_1;
	*corner2 = temp_cell_2;
	return THREE_LINE_CONNECT;
}


int DataCenter::check_connect(CELL_NODE *first, CELL_NODE *second, PATH *path)
{
    int ret=0;
	CELL_NODE *corner1=NULL, *corner2=NULL;
    
	ret = check_0_line_connect(first, second);
	if(ret == NO_CONNECT)
		goto CHECK_CONNECT_RETURN;
    
	ret = check_1_line_connect(first, second);
	if(ret == ONE_LINE_CONNECT)
		goto CHECK_CONNECT_RETURN;
    
	ret = check_2_line_connect(first, second, &corner1);
	if(ret == TWO_LINE_CONNECT)
	{
		goto CHECK_CONNECT_RETURN;
	}
    
	ret = check_3_line_connect(first, second, &corner1, &corner2);
	if(ret == THREE_LINE_CONNECT)
		goto CHECK_CONNECT_RETURN;
    
	return  NO_CONNECT;
    
CHECK_CONNECT_RETURN:
	produce_path(first, second, corner1, corner2, path, ret);
	return ret;
}

int DataCenter::check_die(PATH *path)
{
    int i, k, j;
	CELL_NODE *c1, *c2;
	int ret;
    
	j = rand()%NUMBER;
	i = j;
    
    
	for(k=0;k<NUMBER;k++)
	{
		i++;
		if(i>=NUMBER)
			i=0;
        
		if(g_list[i].count == 0)
			continue;
        
		c1=g_list[i].link;
        
		while((c1!=NULL) && (c1->next!=NULL))
		{
			c2 = c1->next;
			while(c2 != NULL)
			{
				ret = check_connect(c1, c2, path);
				if(ret != NO_CONNECT)
					return ret;
				c2=c2->next;
			}
            
			c1 = c1->next;
		}
	}
	
	return NO_CONNECT;
}


#pragma mark - init 

#warning this method i need to see again.
int DataCenter::init_scenario(int scenario)
{
    int i=0;
	CELL_NODE *temp_c;
    
	switch(scenario)
	{
		case SCENARIO_LEFT_RIGHT:
			for(i=1;i<HEIGHT+1;i++)
			{
				temp_c = get_cell(WIDTH/2, i);
				temp_c->scenario_flag = SCENARIO_FLAG_MARKED;
				temp_c = get_cell(WIDTH/2+1, i);
				temp_c->scenario_flag = SCENARIO_FLAG_MARKED;
			}
			break;
			
		case SCENARIO_UP_DOWN:
			for(i=1;i<WIDTH+1;i++)
			{
				temp_c = get_cell(i, HEIGHT/2);
				temp_c->scenario_flag = SCENARIO_FLAG_MARKED;
				temp_c = get_cell(i, HEIGHT/2+1);
				temp_c->scenario_flag = SCENARIO_FLAG_MARKED;
			}
            
			break;
		case SCENARIO_P_CENTRAL:
			printf("\n current doesn't support Central-Point centrailization");
			break;
            
		default:
			break;
            
	}
	return 0;
}

int DataCenter::adjust_for_average(int diff)
{
    int i, j;
	int total_count;
	int total_node;
	int min_value, max_value;
	int min_node, max_node;
	
	while(1)
	{
		total_count=0;
		total_node=0;
		min_value = 100000;
		max_value = -1;
        
		for(i=0;i<NUMBER;i++)
		{
			j = g_list[i].count;
			if(j>=max_value)
			{
				max_node = i;
				max_value = j;
			}
			if((j<min_value))
			{
				min_node = i;
				min_value = j;
			}
			continue;
		}
        
		if(abs(min_value-max_value)<=1)
			break;
		exchange_in_list(max_node, min_node);
	}
	return 0;
}

int DataCenter::adjust_for_parity()
{
    int i, j;
	int total_count;
	int total_node;
	int min_value, max_value;
	int min_node, max_node;
	
	while(1)
	{
		total_count=0;
		total_node=0;
		min_value = 100000;
		max_value = -1;
        
		for(i=0;i<NUMBER;i++)
		{
			j = g_list[i].count;
			if(j%2==1)
			{
				total_node++;
				if(j>=max_value)
				{
					max_node = i;
					max_value = j;
				}
				if((j<min_value))
				{
					min_node = i;
					min_value = j;
				}
			}
		}
        
		if(total_node==0)
			break;
		exchange_in_list(max_node, min_node);
	}
	return 0;
}


void DataCenter::init_list()
{
    int i;
    
	for(i=0;i<NUMBER;i++)
	{
		g_list[i].count=0;
		g_list[i].link=NULL;
	}
}

void DataCenter::init_cell()
{
    int i, j;
	CELL_NODE *temp_cell;
    
	for (i=0;i<HEIGHT+2;i++)
	{
		for(j=0;j<WIDTH+2;j++)
		{
			temp_cell 	  = g_cell + i*(WIDTH+2)+j;
			temp_cell->column = j;
			temp_cell->row	  = i;
			temp_cell->value 	  = CELL_VALUE_PATH;
			temp_cell->next   = NULL;
			temp_cell->boundary_flag = 1;
			temp_cell->scenario_flag = SCENARIO_FLAG_MARKED;
		}
	}
    
	for (i=1;i<HEIGHT+1;i++)
	{
		for(j=1;j<WIDTH+1;j++)
		{
            
			temp_cell = g_cell + i*(WIDTH+2)+j;
            
			temp_cell->value	= rand()%NUMBER;
			temp_cell->boundary_flag= 0;
			temp_cell->scenario_flag = SCENARIO_FLAG_NO_MARKED;
            
    add_to_list(temp_cell);
		}
	}
}


#pragma mark - list

int DataCenter::remove_from_list(CELL_NODE *cell)
{
    CELL_NODE *temp_c;
    CELL_NODE *temp_c_1;
    int value;
    
    value = cell->value;
    
    temp_c = g_list[value].link;
    
    if (temp_c == cell) {  //如果是链表头。
        g_list[value].link = temp_c->next;
        temp_c->next = NULL;
        g_list[value].count --;
        return 0;
    }
    
    while (temp_c != NULL) {
        temp_c_1 = temp_c;
        temp_c = temp_c_1->next;
        if (temp_c == cell) {
            temp_c_1->next = temp_c->next;
            temp_c->next = NULL;
            g_list[value].count --;
            return 0;
        }
    }
    
    printf("\n remove_from_list error \n");
    
#warning exit is valid;
    exit(0);
}

int DataCenter::add_to_list(CELL_NODE *cell)
{
    int value;
    value = cell->value;
    
    g_list[value].count ++;
    
    cell->next = g_list[value].link;
    
    g_list[value].link = cell;
    return 0;
    
}


void DataCenter::exchange_in_list(int src_v, int dst_v)
{
    CELL_NODE *src_cell;
    int i, j, r;
    
    i = g_list[src_v].count;
    r = rand()%i+1;
    
    src_cell = g_list[src_v].link;
    
    j = 1;
    while (j<r) {
        src_cell = src_cell->next;
        j++;
    }
    
    remove_from_list(src_cell);
    src_cell->value = dst_v;
    add_to_list(src_cell);
    
}

void DataCenter::reproduce_game()
{
    int i, j;
    CELL_NODE *cur_c;
    CELL_NODE *temp_c;
    
    int r;
    int total_leave = 0;
    int k=0;
    
    for (j=0; j<NUMBER; j++) {  //计算总的节点的个数。
        total_leave += g_list[j].count;
    }
    
    for (i=0; i<NUMBER; i++) {
        cur_c = g_list[i].link;
        while (cur_c != NULL) {
            r = rand()%total_leave+1;
            k=0;
            
            for (j=0; j<NUMBER; j++) {
                k+=g_list[j].count;
                if (k>=r) {
                    break;
                }
            }
            
            cur_c->value = j;
            cur_c = cur_c->next;
            g_list[j].count--;
            total_leave--;
            if (total_leave==0) {
                break;
            }
        }
        if (total_leave == 0) {
            break;
        }
    }
    
    init_list();
    
    for (i=0; i<(HEIGHT+2)*(WIDTH+2); i++) {
        temp_c = g_cell + i;
        
        if (temp_c->value == CELL_VALUE_PATH) {//PATH
            continue;
        }
        
        temp_c->next = 0;
        add_to_list(temp_c);
    }
    return;
}


#pragma mark - util..

void DataCenter::init_rand_seed()
{
    time_t lt;
    int seed = 0;
    
    lt = time(NULL);
    seed = lt % 100000000;
    printf("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>seed is %d\n",seed);
    srand(seed);
}


#pragma mark - output....

void DataCenter::refresh_game_scene(CELL_NODE *first, CELL_NODE *second)
{
    int i, j, k;
	CELL_NODE *temp_cell;
	int flag =0;
	int c1,r1, c2, r2;
    
    
	if((first!=NULL) && (second!=NULL))
	{
		c1 = first->column;
		r1 = first->row;
		c2 = second->column;
		r2 = second->row;
		flag = 1;
	}
	
	printf("\n\n=======================================================\n");
    
    //output colume number
	printf("    ");
	for(k=1;k<=WIDTH;k++)
	{
		if(k<10)
			printf("%2d ", k);
		else
			printf("%3d", k);
	}
	printf("\n   ");
    //output separating character
	for(k=1;k<=WIDTH;k++)
		printf("---");
    
	for (i=1;i<HEIGHT+1;i++)
	{
		printf("\n");
		for(j=1;j<WIDTH+1;j++)
		{
			//output row number
			if(j==1)
			{
				if(i<10)
				 	printf("%d  |", i);
				else
				 	printf("%d |", i);
			}
			//output cell content (id)
			temp_cell = get_cell(j, i);
			k=temp_cell->value;
			if(flag==0)
				printf(" %c ", k+97);
			else
			{
				if(((c1==j)&&(r1==i)) || ((c2==j)&&(r2==i)))
					printf(" \033[1;33m%c\033[0m ", k+97);
				else
					printf(" %c ", k+97);
                
			}
		}
	}
	
	printf("\n=======================================================\n");
}






