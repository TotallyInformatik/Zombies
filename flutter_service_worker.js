'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/assets/images/BigZombieRun2.png": "e436d5d9e3e916dfcad2334cc4a61b22",
"assets/assets/images/FloorSpikes.png": "b290886ead56f03430df66ff2cda59a0",
"assets/assets/images/ZombieStandard.png": "731665d54476108085cfd74de7f0af76",
"assets/assets/images/KnightRunInverted2.png": "37e83b729809f3eedf2228fed634c66f",
"assets/assets/images/KnightRun3.png": "3eb216f07e91b2709d17ad29e3761211",
"assets/assets/images/WeaponGreenMagicStaff.png": "a24b09d2b71b22946387e0f5dad44969",
"assets/assets/images/JuggernogFlask.png": "eead2d61472c28a8d46338117686d7fe",
"assets/assets/images/KnightIdle1.png": "5af50adeda2fb3498b5af23e332a66e0",
"assets/assets/images/ZombieRun4.png": "76b450a4e196ee6964e72159f8988d98",
"assets/assets/images/ZombieRun3.png": "d9d0d6c501c8aa50bc87d2e410758f3c",
"assets/assets/images/KnightIdleInverted4.png": "4f2038a5046e8498207341634a85bb3a",
"assets/assets/images/KnightIdle2.png": "7509d58e66b6abba90c927246f2c7bf7",
"assets/assets/images/KnightRunInverted1.png": "baa10a43a5eaf868f72d7191d5901b47",
"assets/assets/images/KnightIdleInverted1.png": "674db99b72443588c7c57f6ef734ada1",
"assets/assets/images/BigZombieRun4.png": "e205f15ecd8fa417497a84e6309b9a1d",
"assets/assets/images/Explosion2.png": "48346cc50089f0de72ceedfc717468b4",
"assets/assets/images/KnightRun4.png": "8fa6627d871b3b94ba343e25a51c4797",
"assets/assets/images/IceZombieRun2.png": "6ce4b55e348ac33b4e2b4735af926b28",
"assets/assets/images/Floor.png": "181cb32a97ef8fce4d92ce012b1c02d8",
"assets/assets/images/Explosion4.png": "bc833c2754ab092b1b08fd14e09feced",
"assets/assets/images/IceZombieRun3.png": "f570d810d6bfd6803aab4755cf3f8ea7",
"assets/assets/images/MuleKickFlask.png": "0179d613675464fedfecee3acf0a7191",
"assets/assets/images/Explosion3.png": "20c5fe02ab7ff1d2195afc577f54901e",
"assets/assets/images/WeaponExcalibur.png": "a952f137a7cca7a84dd41adb08df8ae3",
"assets/assets/images/HeartEmpty.png": "8a370371658a9983d27cb8c71c5d9f63",
"assets/assets/images/KnightRunInverted3.png": "3145ccefdd5228f5f3a6f5c451fb6bbd",
"assets/assets/images/Skull.png": "ba653e43b8fad7d3b9ef85fbd2c61317",
"assets/assets/images/DoubleTapFlask.png": "cfda521c7d5ece3c8290ca4549d53ab9",
"assets/assets/images/SmallZombieRun3.png": "400984f17959de9a275c2cf47b08e0f6",
"assets/assets/images/KnightIdle4.png": "028d9266bb80632faf7c1d2c7046733f",
"assets/assets/images/QuickReviveFlask.png": "43062d398bb93e03fbecf95420319a32",
"assets/assets/images/KnightRun2.png": "f621dc888335bd8d665003de3aaf66bb",
"assets/assets/images/IceZombieRun4.png": "6ce4b55e348ac33b4e2b4735af926b28",
"assets/assets/images/TNTZombieRun3.png": "dae2b515b42b5fd5d10869a96501b5d0",
"assets/assets/images/WeaponSpear.png": "74f9a30a977df32cabb01305d098fac7",
"assets/assets/images/Explosion1.png": "822a5ee71491bdc784d74fc3c01c131a",
"assets/assets/images/Coin.png": "22a5e1fe8cb8fe40fe7b2e3d0b4fff71",
"assets/assets/images/KnightRunInverted4.png": "5e782a3fda972d3894f29aebbaa76f95",
"assets/assets/images/FloorLadder.png": "9b570a3bd0129430eb8401b1a6ebc985",
"assets/assets/images/SmallZombieRun1.png": "9817b193ff4838619a8149285c13e1df",
"assets/assets/images/IceZombieRun1.png": "14cb5655e4aa5a377dc34f68ca04eada",
"assets/assets/images/KnightRun1.png": "a6c811b9c92a19691bc5c35cafa334ce",
"assets/assets/images/BigZombieRun3.png": "d1ae410fe714c83921d7bcbd678548b0",
"assets/assets/images/HeartFull.png": "d275242d91225c968aa946b7439750ff",
"assets/assets/images/SmallZombieRun2.png": "5d0f4d33477ecf1fceb510c9638e4926",
"assets/assets/images/WeaponArrow.png": "c0ae0c8f35ea78f6083d12c3a338403c",
"assets/assets/images/KnightIdleInverted2.png": "6e1ecf4c2722bbc9e243ef8422224945",
"assets/assets/images/KnightIdleInverted3.png": "a511fe637ffab3fabbb551a6748dc53b",
"assets/assets/images/WeaponBow.png": "774dea570816d0ec1f4890659903e03c",
"assets/assets/images/WeaponApprenticesBullet.png": "ded979634f438d11fccceb7f2f02c90b",
"assets/assets/images/TNTZombieRun4.png": "92a8484a6a2302c760a21699f5b5aa72",
"assets/assets/images/ZombieRun2.png": "76b450a4e196ee6964e72159f8988d98",
"assets/assets/images/BigZombieRun1.png": "bc10b4616c267af7ab52ad49e419cfde",
"assets/assets/images/KnightIdle3.png": "0e76e0a6bd1379cc7d61e00d1dae617f",
"assets/assets/images/WeaponRedMagicStaff.png": "caf883affb7f83c9a4366464bbfe6f0f",
"assets/assets/images/TNTZombieRun2.png": "4e5a94dd1b864e993472156daf284880",
"assets/assets/images/SmallZombieRun4.png": "6d7caa5d110d1af939029d4cd6ba6579",
"assets/assets/images/ZombieRun1.png": "731665d54476108085cfd74de7f0af76",
"assets/assets/images/DungeonTilesetII.png": "c8a8bc9368d564439869818fe7c577d6",
"assets/assets/images/TNTZombieRun1.png": "87145c9a791575241634ab400702bb8b",
"assets/assets/tiles/map.tmx": "70602c332cb0da5d134d622c68a1e062",
"assets/assets/tiles/map2.tmx": "f03b0d3a37dd44a6567e37b615816a89",
"assets/assets/tiles/DungeonTilesetII.tsx": "5027b51609687c7c27f2d964c10e017e",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/AssetManifest.json": "8b95ed3c0ce11b145790fa5fa5cb788e",
"assets/NOTICES": "9c29b81c67c9ecb1bcc4c175f4afe682",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"index.html": "c55b918f3644374a62b471595dd43600",
"/": "c55b918f3644374a62b471595dd43600",
"version.json": "32d3b9906fe5063e5adcbb830960e8fe",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"main.dart.js": "7e16d4bafe4d418ec9a6d969e7b7ca8f",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "1174154af760e0db097b46f37014e794",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
