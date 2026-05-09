import std.stdio;
import std.parallelism;
import core.thread;

void workerInit(int workerId){
    int stopPoint = workerId - 2;
    for(int[3] chunkDimensions = [workerId, 250, 16]; chunkDimensions == [stopPoint, 0, 0];){ //Will work on this later, it does not execute the for loop at this time.
        writeln(chunkDimensions);
        if (chunkDimensions[1] > 0){
            --chunkDimensions[1];
            writeln(chunkDimensions);
        } else if (chunkDimensions[2] > 0){
            --chunkDimensions[0];
            chunkDimensions[0] = 250;
            writeln(chunkDimensions);
        } else if (chunkDimensions[2] == 0){
            --chunkDimensions[1];
            chunkDimensions[0] = 250;
            chunkDimensions[2] = 16;
            writeln(chunkDimensions);
        }
    }
    writeln("core id: ", workerId, " | stop point: ", stopPoint); // stops execution here
}


int coreCount(){
    int coreUsage = 3;
    coreUsage = ((totalCPUs <= 12) && (totalCPUs > 7)) ? 8 : coreUsage;
    coreUsage = (totalCPUs >= 16) ? 16 : coreUsage;
    writeln("core usage: ", coreUsage);
    return (coreUsage); //this recalculates coresUsage on call using more CPU but less RAM
}

void chunkBuild(int cores){
    int workLoad = 16/cores;
    writeln("work load: ", workLoad);
    for(int workerCount; workerCount <= 16;){
        workerCount += workLoad;
        auto worker = task!workerInit(workerCount);
        worker.executeInNewThread();
        writeln("worker count: ", workerCount);
    }
}

void main(){
    chunkBuild(coreCount());
}
