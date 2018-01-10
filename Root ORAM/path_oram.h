#ifndef PATH_ORAM_H__
#define PATH_ORAM_H__
#include "tree_oram.h"

/*
Path ORAM simulator.
http://dl.acm.org/citation.cfm?id=2516660
*/

class PathOram: public TreeOram
{
   public:
      PathOram(int logN, int capacity)
         :TreeOram(logN, capacity, logN)
      {
      }

      bool access(int identifier)
      {
         int old_pos = index[identifier];
         bool res = read_and_remove(identifier);
         stash.insert(identifier);
         if (INITIAL)
         {
            update_pos_old(identifier);
         }
         else
         {
            update_pos(identifier);
         }
         flush(old_pos);
         return res;
      }

      void flush(int path)
      {
         // cout << "Flushing " << path << endl;
         vector<int> temp_stash;

         for(int level = 1; level <= h; ++level)
         {
            auto buc = tree[bucket_at(path, level)];
            for(auto &v : buc->blocks)
            {
               if(v != -1)
                  temp_stash.push_back(v);
            }
         buc->clear();
         }

         for(auto &v: stash)
            temp_stash.push_back(v);

         for(int level = h; level >=1; --level)
         {
            auto buc = tree[bucket_at(path, level)];
            for(auto &v:temp_stash)
            {
               if( v != -1
                  and (bucket_at(path,level) == bucket_at(index[v],level) )
                  and (buc->size() < buc->capacity())
                 )
               {
                  buc->add(v);
                  v = -1;
               }
            }
         }
         stash.clear();
         for(auto &v:temp_stash)
            if(v != -1)
               stash.insert(v);
      }
};
#endif// PATH_ORAM_H__
