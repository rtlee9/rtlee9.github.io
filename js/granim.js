var granimInstance = new Granim({
   element: '#canvas',
   name: 'granim',
   // direction: 'left-right',
   opacity: [1, 1],
   states : {
       "default-state": {
           gradients: [
               ['#4b6cb7', '#182848'],
               ['#00bf8f', '#001510']
           ],
	    transitionSpeed: 10000
       }
   }
});
