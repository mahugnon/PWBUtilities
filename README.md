# PWBUtilities
```Smalltalk
 Metacello new
    	githubUser: 'mahugnon' project: 'PWBUtilities' commitish: 'main' path: 'src';
    	baseline: 'PWBUtilities';
	 onConflict: [ :e | e useIncoming ];
        onUpgrade: [ :e | e useIncoming ];
        
    	load
      ```
