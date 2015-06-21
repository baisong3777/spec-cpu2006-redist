List parse_string _((char *s));
int zsetlimit _((int limnum, char *nam));
int setlimits _((char *nam));
pid_t zfork _((void));
int execcursh _((Cmd cmd));
int zexecve _((char *pth, char **argv));
int isgooderr _((int e, char *dir));
void execute _((Cmdnam not_used_yet, int dash));
char * findcmd _((char *arg0));
int iscom _((char *s));
int isrelative _((char *s));
Cmdnam hashcmd _((char *arg0, char **pp));
void execstring _((char *s, int dont_change_job, int exiting));
void execlist _((List list, int dont_change_job, int exiting));
int execpline _((Sublist l, int how, int last1));
void execpline2 _((Pline pline, int how, int input, int output, int last1));
char ** makecline _((LinkList list));
void untokenize _((char *s));
int clobber_open _((struct redir *f));
void closemn _((struct multio **mfds, int fd));
void closemnodes _((struct multio **mfds));
void closeallelse _((struct multio *mn));
void addfd _((int forked, int *save, struct multio **mfds, int fd1, int fd2, int rflag));
void addvars _((LinkList l, int export));
void execcmd _((Cmd cmd, int input, int output, int how, int last1));
void save_params _((Cmd cmd, LinkList *restore_p, LinkList *remove_p));
void restore_params _((LinkList restorelist, LinkList removelist));
void fixfds _((int *save));
void entersubsh _((int how, int cl, int fake));
void closem _((int how));
char * gethere _((char *str, int typ));
int getherestr _((struct redir *fn));
LinkList getoutput _((char *cmd, int qt));
LinkList readoutput _((int in, int qt));
List parsecmd _((char *cmd));
char * getoutputfile _((char *cmd));
char * namedpipe _((void));
char * getproc _((char *cmd));
int getpipe _((char *cmd));
void mpipe _((int *pp));
void spawnpipes _((LinkList l));
int execcond _((Cmd cmd));
int execarith _((Cmd cmd));
int exectime _((Cmd cmd));
int execfuncdef _((Cmd cmd));
void execshfunc _((Cmd cmd, Shfunc shf));
void doshfunc _((List list, LinkList doshargs, int flags, int noreturnval));
List getfpfunc _((char *s));
char * cancd _((char *s));
int cancd2 _((char *s));
void execsave _((void));
void execrestore _((void));