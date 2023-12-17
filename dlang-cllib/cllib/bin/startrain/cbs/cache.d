module cllib.bin.startrain.cbs.cache;

import std.algorithm;

import std.bigint;

import std.digest;


/**
 * Removes a terminal reference from the cache, allowing its memory to be freed.
 * @param terminal The terminal to remove.
 */
export void removeTerminalFromCache(terminal, Terminal) (ref Permutations) {
  for (let i = 0; i < charAtlasCache.length; i++) {
    const index = charAtlasCache[i].ownedBy.indexOf(terminal);
    if (index != -1) {
      if (charAtlasCache[i].ownedBy.length == 1) {
        // Remove the cache entry if it's the only terminal
        charAtlasCache[i].atlas.dispose();
        charAtlasCache.splice(i, 1);
      } else {
        // Remove the reference from the cache entry
        charAtlasCache[i].ownedBy.splice(index, 1);
      }
      break;
    }
  }
}



