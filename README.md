# **Processor_Cache_Design**
The two caches implemented are instruction cache and data cache. Each cache has 2KB in size, 2 way set-associative, with cache blocks 16B each.

# Cache Write Policy & Cache Read Policy
Cache write policy is write-through and write-allocate. Cache read policy is reading from the cache for a hit; on a miss, the data is brought back from main memory to the cache and then the required word (from the cache block) is read out.

# Processor And Cache Block Diagram
![Processor_Block_Diagram2](https://github.com/RookieT0T/Processor_Cache_Design/assets/125717952/0eeda4c7-ff9b-4eee-ab2e-2fac5c745d62)
