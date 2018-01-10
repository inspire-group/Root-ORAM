#include "path_oram.h"
#include <iostream>
#include <map>
#include <fstream>
#include <cmath>
#include "test.h"
using namespace std;


int main(int argc, char ** argv )
{
   /* Input variable parsing */
   if (argc != 5){
      cout << "Error: format is ./a.out LOG_N BUCKET_SIZE I_VALUE EPSILON" << endl;
      exit(1);
   }
   int logN = stoi(string(argv[1]));
   int cap = stoi(string(argv[2]));
   int varI = stoi(string(argv[3]));
   double epsilon = atof(argv[4]);
   // if ((varI > logN-1) || (varI < 1)){
   //    cout << "Error: I_VALUE should be between 1 and LOG_N-1" << endl;
   //    exit(1);
   // }
   if (epsilon < 0){
      cout << "Error: EPSILON should be non-negative" << endl;
      exit(1);
   }

   /* Initialization */
   long long N = (1<<logN);
   PathOram oram(logN, cap);
   oram.set_values(varI, epsilon);  
   long long i = 0;
   int warmup = 1<<15;
   map<long long, long long> counter;

   // for (int i = 0; i < 10; ++i)
   // {
   //    oram.update_pos(1);
   //    cout << oram.index[1] << endl;
   // }
   // exit(1);

   // for (int i = 0; i < 10; ++i)
   // {
   //    oram.access(i%N);
   //    oram.print_all();
   //    cout << "Stash\t" << oram.stash.size() << endl;
   //    for (int i = 1; i <= logN; ++i)
   //    {
   //       cout << i << "\t" << oram.level_i_size(i) << endl;
   //    }
   // }
   // exit(1);
   
   /* Warmup */
   cout <<"Starting warmming up with "<< (N > warmup ? N : warmup) <<" operations."<<endl;
   for(int i = 0; i < (N > warmup ? N : warmup); ++i)
   {
      oram.access(i%N);
   }
   i = 0;
   oram.warmup_complete();
   cout <<"Warmup completed."<<endl;
   

   while(true)
   {
      bool res = oram.access(i%N);
      if(not res)
      {
         cout<<"tree oram invariance is broken"<<i<<endl;
      }
      ++counter[oram.stash.size() + oram.total_stash()];
      ++i;
      if((i%500000) == 0){
         // pruint64_t(i, counter, string("path")+"_"+string(argv[1]), cap);
         pruint64_t(i, counter, string("path")+"_"+string(argv[1])+"_"+string(argv[2]), varI, epsilon);
         exit(1);
      }
   }
}
