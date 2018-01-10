// For both
#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>

// For server
#include <netdb.h>

// For client


#define PORT 10000
#define BUF_SIZE 1024
#define CONSTANTS 10
#define IP_ADDRESS "52.10.206.130"


int client(const char* filename, int k)
{
    /* Create file where data will be stored */
    FILE *fp = fopen(filename, "ab");
    if(NULL == fp)
    {
        printf("Error opening file");
        return 1;
    }

    /* Create file where time will be stored */
    FILE *fd_time = fopen("time_taken.txt", "a");
    if (fd_time == NULL)
    {
      printf("Error opening file!\n");
      return 1;
    }    

    /* Create a socket first */
    int sockfd = 0;
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0))< 0)
    {
        printf("\n Error : Could not create socket \n");
        return 1;
    }

    /* Initialize sockaddr_in data structure */
    struct sockaddr_in serv_addr;
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT+k); // port
    serv_addr.sin_addr.s_addr = inet_addr(IP_ADDRESS);

    /* Attempt a connection */
    if(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr))<0)
    {
        printf("\n Error : Connect Failed \n");
        return 1;
    }

    /* Receive data in chunks of BUF_SIZE bytes */
    int bytesReceived = 0;
    char buff[BUF_SIZE];
    memset(buff, '0', sizeof(buff));

    clock_t t;
    t = clock();
    while((bytesReceived = read(sockfd, buff, BUF_SIZE)) > 0)
    {
        printf("Bytes received %d\n",bytesReceived);
        fwrite(buff, 1,bytesReceived,fp);
    }
    t = clock() - t;
    double time_taken = ((double)t)/CLOCKS_PER_SEC; // in seconds

    /* Write this time to a file */
    fprintf(fd_time, "%f\t", time_taken);

    if(bytesReceived < 0)
    {
        printf("\n Read Error \n");
    }
    
    fclose(fd_time);
    fclose(fp);

    return 0;
}


int server(const char * filename, int k)
{
    int listenfd = socket(AF_INET, SOCK_STREAM, 0);

    printf("Socket retrieve success\n");

    struct sockaddr_in serv_addr;
    memset(&serv_addr, '0', sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(PORT+k);

    bind(listenfd, (struct sockaddr*)&serv_addr,sizeof(serv_addr));

    if(listen(listenfd, 10) == -1)
    {
        printf("Failed to listen\n");
        return -1;
    }

    for (;;)
    {
        int connfd = accept(listenfd, (struct sockaddr*)NULL ,NULL);

        int temp = (k+1) * CONSTANTS;
        for (int i = 0; i < temp; ++i)
        {
	        /* Open the file that we wish to transfer */
	        FILE *fp = fopen(filename,"rb");
	        if(fp==NULL)
	        {
	            printf("File opern error");
	            return 1;
	        }

	        /* Read data from file and send it */
	        for (;;)
	        {
	            /* First read file in chunks of BUF_SIZE bytes */
	            unsigned char buff[BUF_SIZE]={0};
	            int nread = fread(buff,1,BUF_SIZE,fp);
	            printf("Bytes read %d \n", nread);

	            /* If read was success, send data. */
	            if(nread > 0)
	            {
	                printf("Sending \n");
	                write(connfd, buff, nread);
	            }

	            /*
	             * There is something tricky going on with read ..
	             * Either there was error, or we reached end of file.
	             */
	            if (nread < BUF_SIZE)
	            {
	                if (feof(fp))
	                    printf("End of file\n");
	                if (ferror(fp))
	                    printf("Error reading\n");
	                break;
	            }	
	        }
            fclose(fp);
        }
        close(connfd);
        // sleep(1);
    }

    return 0;
}

int main(int argc, char** argv)
{
    if (argc == 4)
    {
        const char* mode = argv[1];
        const char* filename = argv[2];
        int k = atoi(argv[3]);
        if (strcmp(mode, "client") == 0)
            return client(filename,k);
        else if (strcmp(mode, "server") == 0)
            return server(filename,k);
        else
            printf("Invalid mode %s - should be 'client' or 'server'\n",mode);
    }
    else
    {
        printf("Invalid number of arguments, usage is : \n");
        printf("1. %s server [FILENAME] [k VALUE] for server\n", argv[0]);
        printf("1. %s client [FILENAME] [k VALUE] for client\n", argv[0]);
    }
    return 1; // Something went wrong
}