
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <sstream>
#include <algorithm>
#include <numeric>
#include <iterator>

using namespace std;

struct Tree;
struct Node; 


#define INTERNAL (0)
#define BORDER (1)
#define LEAF (2)

#define MAX_N (1000*1000 + 100)
#define MAX_M (1000*1000 + 100)
#define MAX_BERNOULLI (1000*100)
#define MAX_TRIALS (10000)
#define AVERAGING_SIZE (10)

int c_id = 0;

Node* mapping[MAX_N];

/* 	First index of data_to_id is 1. This stores the mapping of the elements.
	data_to_id[1] will give the ID of the Node of the leaf to which 1 is
	mapped */

int data_to_id[MAX_N];					

vector<int> max_stash_tracker;

int stash[MAX_N];

int stash_size = 0;

vector<int> stash_size_dist;

vector<int> prob_dist;

int n = 0;

double p = 0;

Tree* tree;



struct Node
{
	int ID;
	vector<int> data;
	int bucket_size;
	int max_depth;
	int depth;
	vector<Node*> children;
	
	Node* parent; 

	Node(int _bucket_size, int _max_depth, int _depth, int fanout, Node* _parent)
	{
		ID = c_id++; 
		mapping[ID] = this;
		bucket_size = _bucket_size;
		max_depth = _max_depth;
		depth = _depth;
		parent = _parent;
		if ( type() == INTERNAL)
		{
			children.resize(2);
			for ( int i = 0 ; i < children.size() ; i++)
				children[i] = new Node(bucket_size,max_depth,depth+1,fanout,this);
		} 
		else if ( type () == BORDER)
		{
			children.resize(fanout);
			for ( int i = 0 ; i < children.size() ; i++)
				children[i] = new Node(bucket_size,max_depth,depth+1,fanout,this);	
		}
		else children.resize(0);

		data.assign(bucket_size,0);
	}

	int type()
	{
		if ( depth < max_depth-1)
			return INTERNAL;
		else if (depth == max_depth-1)
			return BORDER;
		else 
			return LEAF;
	}

	string content()
	{
		stringstream ss;
		ss << ID << ":(";
		for ( int i = 0 ; i < data.size()-1;i++)
		{
			ss << data[i] << ',';
		}
		ss << data.back() << ")";
		return ss.str();
	}
	bool is_root(){
		return parent == NULL;
	}

	vector<Node*> path_to_root(){

		vector<Node*> ret;
		Node* pointer = this;
		do{
			ret.push_back(pointer);
			pointer = pointer->parent;
		}while(!pointer->is_root());
		
		ret.push_back(pointer);
		
		reverse(ret.begin(),ret.end());

		return ret;
	}
	int find_data(int d){
		for ( int i = 0 ; i < data.size() ; i++)
			if ( data[i] == d)
				return i;
		return -1;
	}

	void change_random_non_zero(){
		random_shuffle(data.begin(),data.end());
	
		for ( int i = 0 ; i < data.size() ; i++)
			if ( data[i] != 0 ){
				stash[stash_size++] = data[i];
				if (stash_size > 1)
				{
					swap(stash[stash_size-1],stash[stash_size-2]);
				}
				data[i] = 0;
				return;
			}
	}
};



struct Tree
{
	int max_depth; 
	

	Node *root; 
	vector<Node*> leaves;

	int logsize; 
	int bucket_size;
	
	Tree(int _logsize,int _max_depth,int _bucket_size)
	{
		logsize = _logsize;
		max_depth = _max_depth;
		bucket_size = _bucket_size;
		root = new Node(bucket_size,max_depth,0,fanout(),NULL);
		find_leaves(root);
		
	}
	
	int fanout()
	{
		return pow(2,logsize - max_depth + 1);
	}

	void traverse()
	{
		traverse(root,0);
	}
	
	void traverse(Node* node,int tab)
	{
		if ( node == NULL)
			return;

		for ( int i = 0 ; i < tab ; i++)
			cout << '\t';

		cout << node->content() << endl;

		for ( int i = 0 ; i < node->children.size() ; i++)
			traverse(node->children[i],tab+1);
	}

	void find_leaves(Node* node){
		if ( node == NULL)
			return;
		if (node->type() == LEAF)
			leaves.push_back(node);

		for ( int i = 0 ; i < node->children.size();i++)
			find_leaves(node->children[i]);
	}


	Node* common_ancestor(Node* leaf1, Node* leaf2){

		vector<Node*> p1 = leaf1->path_to_root();
		vector<Node*> p2 = leaf2->path_to_root();

		for ( int i = 0 ; i < p1.size();i++){
			if (p1[i] != p2[i])
				return p1[i-1];
		}
		return leaf1;
	}


	void read_path(int data){
		int id = data_to_id[data];
		Node* node = mapping[id];
		
		vector<Node*> path = node->path_to_root();

		for ( int i = 0 ; i < path.size();i++){
			int index = path[i]->find_data(data);
			if ( index != -1){ // We found the index of the data in path[i] node. 
				stash[stash_size++] = path[i]->data[index];
				path[i]->data[index] = 0; // make the entry zero. 
				return;
			}
		}
	
		// only reach if not found in the for-loop (in the tree).
		for ( int i = 0 ; i < stash_size ; i++){
			if (stash[i] == data)
				swap(stash[stash_size-1],stash[i]);
		}
	}


	int check_if_last(int data){
		if (stash[stash_size-1] == data)
		{
			return 0;
		}
		return 1;
	}


	// void write_path(int data, Node* com_anc){
	// 	for (int i = 0; i < com_anc->data.size(); ++i){
	// 		if (com_anc->data[i] == 0){
	// 			com_anc->data[i] = data;
	// 			stash[stash_size-1] = 0;
	// 			stash_size--;
	// 			return;
	// 		}
	// 	}
	// }


	void write_path(int data, Node* com_anc){
		do{
			for (int i = 0; i < com_anc->data.size(); ++i){
				if (com_anc->data[i] == 0){
					com_anc->data[i] = data;
					stash[stash_size-1] = 0;
					stash_size--;
					return;
				}
			}
			com_anc = com_anc->parent;
		}while(com_anc!=NULL);
	}


	Node* random_node_on_path(Node* leaf){
		vector<Node*> path = leaf->path_to_root();
		int in = prob_dist[rand()%prob_dist.size()];
		return path[in];
	}


	void push_to_tree(int id){
		for (int i = stash_size-1; i >= 0; i--){
			if (data_to_id[stash[i]] == id){
				Node* leaf = mapping[id];

				for (int j = 0; j < leaf->data.size(); ++j){
					if (leaf->data[j] == 0){
						leaf->data[j] = stash[i];
						stash[i] = 0;
						swap(stash[i], stash[stash_size-1]);
						stash_size--;
						break;
					}
				}
			}
		}
	}


	int update_mapping(Node* leaf){
		if (((double) rand() / (RAND_MAX)) < (n*p/(n-1))){
			return tree->leaves[rand()%n]->ID;
		}
		else{
			return leaf->ID;
		}
	}
	

	void push_down(int old_location){
		
		Node* leaf = mapping[old_location];
		Node* mapped_leaf;
		Node* ancestor;

		vector<Node*> path = leaf->path_to_root();
		for (int i = (path.size()) - 2; i >= 0; --i){
			for (int j = 0; j < path[i]->data.size(); ++j){
				if (path[i]->data[j] != 0){
					int temp = path[i]->data[j];
					path[i]->data[j] = 0;

					mapped_leaf = mapping[data_to_id[temp]];
					ancestor = tree->common_ancestor(mapped_leaf, leaf);

					do{
						int index = ancestor->find_data(0);
						if (index != -1){ 
							ancestor->data[index] = temp;
							break;
						}
						ancestor = ancestor->parent;
					}while(ancestor!=NULL);
				}
			}
		}
	}


	void initialize_tree(){
		for (int i = stash_size-1; i >= 0; i--)
		{
			int element = stash[i];
			int location = data_to_id[element];

			Node* leaf = mapping[location];
			do{
				int index = leaf->find_data(0);
				if (index != -1){ 						// Found an empty space in com_anc node. 
					stash[i] = 0;
					swap(stash[i],stash[stash_size-1]);
					stash_size--;
					leaf->data[index] = element;
					break;
				}
				leaf = leaf->parent;
			}while(leaf!=NULL);
		}
		return;
	}

};


void print_stash(){
	cout << "Stash : ";
	for ( int i = 0 ; i < stash_size; i++)
		cout << stash[i] << ' ';
	cout << endl;
}


void prints(){
	cout << "Data To ID" << endl;
	for ( int i = 1 ; i<=n ; i++)
		cout << i << " : " << data_to_id[i] << "  ";
	cout << endl;
	cout << "Stash" << endl;

	for ( int i = 0 ; i < stash_size; i++)
		cout << stash[i] << ' ';
	cout << endl;

}


void create_prob(int k){
	if ( k == 1 ){
		prob_dist.push_back(0); 
		return;
	}
	int x = 0;
	for ( int i = k-2 ; i < k ; i++){
		prob_dist.push_back(i);
	}
	int count = 1; 
	for ( int i = k-3 ; i >= 0 ; i--){
		count = 2*count;
		for ( int j = 0 ; j < count ; j++)
			prob_dist.push_back(i);
	}
}


void initialize(int L,int k,int Z){
	
	n = pow(2,L);
	// p = 1 - pow(2,-((double) pow(k,2)/L));
	p = 1 - pow(2,-k);
	
	c_id = 0;
	stash_size = 0;
	prob_dist.clear();		


	for (int i = 0; i < MAX_N; ++i)
	{
		stash[i] = 0;
	}

	tree = new Tree(L,k,Z);
	for ( int i = 1 ; i <= n ; i++){
		data_to_id[i] = tree->leaves[rand()%n]->ID;
		stash[stash_size++] = i;
	}

	create_prob(k);
}


int poisson(double lambda)
{
	int k = 0;
	double L = exp(-lambda);
	double q = 1;
	do
   	{
    	k = k+1;
    	q = q*((double)rand() / (double)((unsigned)RAND_MAX + 1));
   	}while(q > L);

	return k-1;
}



int main(int argc, char const *argv[])
{
	srand(time(NULL));

	int L, k, Z;
	double lambda;
	lambda = 0.5;

	if (argc != 4)
	{
		cout << "Error : more inputs needed" << endl;
		return 1;
	}
		
	istringstream ( argv[1] ) >> L;
	istringstream ( argv[2] ) >> k;
	istringstream ( argv[3] ) >> Z;


	Node* random_leaf;
	int x, real_accesses, total_accesses;
	int old_location, new_location, max_stash_usage;
	max_stash_tracker.clear();


	for (int counter = 0; counter < AVERAGING_SIZE; ++counter)
	{
		cerr << counter+1 << " of (" << L << "," << k << "," << Z << ")" << endl; 

		initialize(L,k,Z);
		tree->initialize_tree();


		Node* random_leaf;
		real_accesses = 0;
		total_accesses = 0;
	  	max_stash_usage = stash_size;


		while(real_accesses < MAX_TRIALS)
		{
			x = poisson(lambda);
			for (int ii = 0; ii < x; ++ii)
			{
				int element = (rand()%n) + 1;
				tree->read_path(element);
				
				random_leaf = tree->random_node_on_path(mapping[data_to_id[element]]);
				random_leaf->change_random_non_zero();

				old_location = data_to_id[element];
				new_location = tree->update_mapping(mapping[data_to_id[element]]);
				data_to_id[element] = new_location;

				Node* com_anc = tree->common_ancestor(mapping[old_location],mapping[new_location]);
				tree->write_path(element, com_anc);
				tree->push_to_tree(old_location);
				tree->push_down(old_location);

				real_accesses++;
				total_accesses++;
				if (max_stash_usage < stash_size)
				{
					max_stash_usage = stash_size;
				}
			}
			if (stash_size > 0)
			{
				int element = stash[(rand()%stash_size)];
				tree->read_path(element);

				old_location = data_to_id[element];
				new_location = tree->update_mapping(mapping[data_to_id[element]]);
				data_to_id[element] = new_location;

				Node* com_anc = tree->common_ancestor(mapping[old_location],mapping[new_location]);
				tree->write_path(element, com_anc);
				tree->push_to_tree(old_location);
				tree->push_down(old_location);

				total_accesses++;
				if (max_stash_usage < stash_size)
				{
					max_stash_usage = stash_size;
				}	
			}
		}

		max_stash_tracker.push_back(max_stash_usage);
	}

	double sum = accumulate(max_stash_tracker.begin(), max_stash_tracker.end(), 0.0);
	double mean = sum / max_stash_tracker.size();
	
	cout << mean << "\t";

	return 0;
}

