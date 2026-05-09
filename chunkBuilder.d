import std.stdio;
import std.parallelism;

struct chunkBuild{

}

int coreCount(){
    int coreUsage = 4;
    coreUsage = (totalCPUs > 4) ? (coreUsage = totalCPUs - 4) : coreUsage;
    writeln(coreUsage); //this recalculates coresUsage on call using more CPU but less RAM
    return (coreUsage);
}

void chunkBuild(){

}

void main(){

}
