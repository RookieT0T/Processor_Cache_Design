# **Processor_Cache_Design**
The two caches implemented are the instruction cache and the data cache. Each cache is 2KB in size, 2-way set-associative (with LRU replacement policy), with cache blocks 16B each.

## Cache Write Policy & Cache Read Policy
Cache write policy is write-through and write-allocate. Cache read policy is reading from the cache for a hit; on a miss, the data is brought back from main memory to the cache and then the required word (from the cache block) is read out.

## Cache Miss Handler
It is implemented by finite state machines, which cooridnate the behaviors of caches and the main memory.

## Memory Contention On Cache Misses
It is possible that instruction cache miss and data cache miss are simultaneously requested, but only one cache miss can be processed. The other one should request stall for an extended period of time, i.e. after one cache miss becomes cache hit.

## Processor & Cache Block Diagram
![Processor_Block_Diagram2](https://github.com/RookieT0T/Processor_Cache_Design/assets/125717952/0eeda4c7-ff9b-4eee-ab2e-2fac5c745d62)
