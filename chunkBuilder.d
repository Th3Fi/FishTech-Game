import std.stdio;
import std.parallelism;
import core.thread;

void workerInit(int workerId){
    int stopPoint = workerId - 2;
    int[3] chunkGen = [workerId, 250, 16];
    while(chunkGen[] != [stopPoint, 0, 0]){
        writeln("worker init  : ", chunkGen, " worker id: ", workerId);
        --chunkGen[1];
        if((chunkGen[1] == 0) && (chunkGen[2] > 0)){
            --chunkGen[2];
            chunkGen[1] = 250;
        } else if ((chunkGen[2] == 0) && (chunkGen[0] > stopPoint)){
            --chunkGen[0];
            chunkGen[1] = 250;
            chunkGen[2] = 16;
        }
    }
    writeln("worker init  : core id: ", workerId, " | stop point: ", stopPoint);
}


int coreCount(){
    int coreUsage = 3;
    coreUsage = ((totalCPUs <= 12) && (totalCPUs > 7)) ? 8 : coreUsage;
    coreUsage = (totalCPUs >= 16) ? 16 : coreUsage;
    writeln("core count    : core usage: ", coreUsage);
    return (coreUsage); //this recalculates coresUsage on call using more CPU but less RAM
}

void chunkBuild(int cores){
    int workLoad = 16/cores;
    writeln("chunk build    : work load: ", workLoad);
    for(int workerCount; workerCount <= 14;){
        workerCount += workLoad;
        auto worker = task!workerInit(workerCount);
        worker.executeInNewThread();
        writeln("chunk build   : worker count: ", workerCount);
    }
}

void main(){
    chunkBuild(coreCount());
}
