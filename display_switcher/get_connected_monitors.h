#ifndef GET_CONNECTED_MONITOR_H
#define GET_CONNECTED_MONITOR_H

#include <stdbool.h>

#define MAX_NAME_LEN 128
#define MAX_DESC_LEN 256
#define MAX_MODES 64
#define MAX_MONITORS 10

typedef struct {
    int id;
    char name[MAX_NAME_LEN];
} Workspace;

typedef struct {
    int id;
    char name[MAX_NAME_LEN];
    char description[MAX_DESC_LEN];
    char make[MAX_NAME_LEN];
    char model[MAX_NAME_LEN];
    char serial[MAX_NAME_LEN];
    int width;
    int height;
    float refresh_rate;
    int x;
    int y;
    Workspace active_workspace;
    Workspace special_workspace;
    int reserved[4];
    float scale;
    int transform;
    bool focused;
    bool dpmsStatus;
    bool vrr;
    int solitary;
    bool activelyTearing;
    char directScanoutTo[MAX_NAME_LEN];
    bool disabled;
    char currentFormat[MAX_NAME_LEN];
    char mirrorOf[MAX_NAME_LEN];
    char availableModes[MAX_MODES][MAX_NAME_LEN];
    int mode_count;
} MonitorInfo;

typedef struct {
    MonitorInfo monitors[MAX_MONITORS];
    int count;
} MonitorList;

MonitorList get_connected_monitors(void);

#endif

