/**
 * @format
 */

import { main } from './output/Main/index.js';

try {
  console.log('=== CALLING MAIN ===');
  main();
  console.log('=== MAIN COMPLETED ===');
} catch(e) {
  console.error('=== STARTUP ERROR ===');
  console.error(e.message);
  console.error(e.stack);
}
