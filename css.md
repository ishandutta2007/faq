#### CSS

Auto resize images

    <style>
     img {
          max-width: 100%;
          max-width: 100%;
          height: auto\9;
          width: auto\9; /* ie8 */
     }
    </style>

Basic table

    /* ----------------------------------------------------
     simple css table implementation
     <div class="csstable">
     <span><p>A1</p><p>A2</p><p>A3</p></span>
     <span><p>B1</p><p>B2</p><p>B3</p></span>
     </div>
     */
    
    .csstable {
     display: table;
    }
    
    .csstable span {
     display: table-row;
    }
    
    .csstable span p {
     display: table-cell;
     vertical-align: middle;
     text-align: left;
    }

