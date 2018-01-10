#ifndef TREE_ORAM_H__
#define TREE_ORAM_H__
#include "bucket.h"
#include <vector>
#include <set>
#include <random>
#include <iostream>
#include <iomanip>
using std::vector;
using std::set;
using std::cout;
using std::endl;

class TreeOram
{
   public: 
      vector<Bucket<int>*> tree;
      set<int> stash;
      vector<int> index;
      std::mt19937 rg;
      std::uniform_int_distribution<int> uni;
      std::uniform_real_distribution<double> distribution;
      bool INITIAL = true;
      int N, logN, h, Z, varI;
      double pValue;
      TreeOram(int _logN, int buck_size, int _h)
      {
         rg.seed(time(0));
         logN = _logN;
         h = _h;
         Z = buck_size;
         N = 1<<logN;
         uni = std::uniform_int_distribution<int>(0, (1<<(h-1))-1);
         distribution = std::uniform_real_distribution<double> (0.0,1.0);
         for(int i = 0; i < 1<<h; ++i)
            tree.push_back(new Bucket<int>(buck_size));
         index.assign(N+1, -1);
         for(int i = 0; i <= index.size(); ++i)
            index[i] = uni(rg);
      }

      ~TreeOram() {
         for(auto & v : tree) 
            delete v;
      }

      /* Indicator for initialization step completion */
      void warmup_complete()
      {
         INITIAL = false;
      }

      /* Find the total stash usage i.e., the number of 
      blocks stored in the top varI levels */
      int total_stash ()
      {
         int ret = 0;
         for (int i = 0; i < varI; ++i)
         {
            ret += level_i_size(i);
         }
         return ret;
      }

      /* Find the stash usage of the "level"th level i.e., 
      the number of blocks stored in the "level"th level */
      int level_i_size(int level) 
      {
         int ret = 0;
         for (int i = 0; i < 1 << (level-1); ++i)
         {
            ret += tree[bucket_at(i*(1<<(h-level)), level)]->size();
         }
         return ret;
      }

      // /* Delta type distribution, the current leaf has a higher probability
      // and everything else has small probability */
      // void update_pos(int identifier) 
      // {
      //    if (distribution(rg) < (double)N*pValue/(double)(N - 2)) 
      //    {
      //       index[identifier] = uni(rg);
      //    }
      // }

      /* Current sub-tree has higher probability and rest of the tree has 
      uniform smaller probability */
      void update_pos(int identifier) 
      {
         if (distribution(rg) < pValue) 
         {
            index[identifier] = uni(rg);
         }
         else
         {
         	int subtree_leaf = index[identifier];
         	int subtree_root = subtree_leaf/(1 << (h - varI));
         	index[identifier] = ((subtree_root * (1 << (h - varI))) + 
         						(uni(rg) % (1 << (h - varI)))); // Random offset in subtree
			// cout << subtree_leaf << ' ' << subtree_root * (1 << (h - varI)) << ' ';
         }
      }

      void set_values (int _varI, double epsilon) 
      {
      	varI = _varI;
      	// pValue = 1/(1 + (2*exp(epsilon/2.0)/(N - 2)));
        pValue = (1 << varI)/(double)((1 << varI) - 1.0 + exp(epsilon/2.0)); // Sub-tree function
      }

      
      void update_pos_old(int identifier)
      {
         index[identifier] = uni(rg);
      }

      int push_distance(int l1, int l2)
      {
         if(l1 == l2)return h;
         l1 += (1UL<<(h-1)) ;
         l2 += (1UL<<(h-1)) ;
         int res = 0;
         unsigned int diff = l1 ^ l2;
         if( (diff & 0xFFFF0000) == 0)
         {
            res += 16;
            diff <<= 16;
         }
         if( (diff & 0xFF000000) == 0)
         {
            res +=8;
            diff <<= 8;
         }
         if((diff & 0xF0000000) == 0)
         {
            res += 4;
            diff <<=4;
         }
         if((diff & 0xC0000000) == 0)
         {
            res += 2;
            diff <<=2;
         }
         if((diff & 0x80000000)==0)
         {
            res +=1;
         }
         return res-32+h;
      }

      int bucket_at(int leaf_label, int level) 
      {
         int label_in_tree = leaf_label + (1UL<<(h-1)) ;
         return (label_in_tree >> (h - level));
      }

      bool read_and_remove(int pos)
      {
         bool found = false;
         int index_pos = index[pos];
         for(int level = 1; level <= h; ++level)
         {
            int iter = bucket_at(index_pos, level);
            bool here = tree[iter]->read_and_remove(pos);
            found = found or here;
            if(here)break;
         }
         bool here = stash.find(pos) != stash.end();
         stash.erase(pos);
         //if(stash.size() > 10000)
         //   cout <<"Warning: stash size is likely to be unbounded."<<stash.size()<<endl;
         return (found or here);
      }

      /* Print position map, stash and tree */
      void print_all() {
         print_position_map();
         print_stash();
         print_tree();
      }

      void print_position_map() {
         cout << "Position Map: ";
         for (int i = 0; i < N; i++) {
            cout << i << ": " << index[i] << '\t';
         }
         cout << endl;
      }

      void print_stash() {
         cout << "Stash: ";
         for (set<int>::iterator iter = stash.begin(); iter != stash.end(); ++iter)
         {
            cout << *iter << '\t';
         }
         cout << endl;
      }

      void print_tree() 
      {
         int left_spacing = (1<<(h-1)) - 1;
         int inter_spacing =  (1<<h) - 1;
         int no_buckets = 1;
         for (int i = 1; i <= h; ++i)
         {
            for (int j = 0; j < Z; ++j)
            {
               for (int k = 0; k < left_spacing; ++k){cout << "   ";}
               for (int k = 0; k < no_buckets; ++k)
               {
                  cout << std::setw(6) << tree[bucket_at(k*(1<<(h-i)), i)]->blocks[j];
                  for (int l = 0; l < left_spacing; ++l){cout << "      ";}
               }
               cout << endl;
            }
            left_spacing >>= 1;
            inter_spacing >>= 1;
            no_buckets <<= 1;
         }
      }
};
#endif //TREE_ORAM_H__
