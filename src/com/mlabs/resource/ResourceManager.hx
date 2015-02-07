package com.mlabs.resource;

import com.mlabs.resource.Resources;

class ResourceManager {
   static public var instance(getInstance, null): ResourceManager;

   static public function getInstance(): ResourceManager {
      if (instance == null)
         instance = new ResourceManager();

      return instance;
   }

   var resources: Hash<Dynamic>;

   public function new() {
      resources = new Hash<Dynamic>();
   }

   public function get(id: String, unique : Bool = true): Dynamic {
      if (unique || !resources.exists(id)) {
         var typ = Type.resolveClass(id);
         if (typ == null) {
            trace("Could not resolve class: " + id);
            return null;
         }

         var inst = Type.createInstance(typ, []);

         if (unique)
            return inst;

         resources.set(id, inst);
      }

      return resources.get(id);
   }
}

