library(httpuv)


s <- startServer("127.0.0.1",
                 5500,
                 list(
                   staticPaths = 
                     list("/" = "."
                     ),
                   staticPathOptions = staticPathOptions(indexhtml = TRUE),
                   onWSOpen = function(ws) {
                     cat("Connection opened.\n")
                     
                     ws$onMessage(function(binary, message) {
                       
                       ok <- jsonlite::fromJSON(message)
                       
                       if(ok$method == "check"){
                         ok$message <- "Connected !"
                         print(ok)
                         
                       }else if(ok$method == "graph"){
                         print(ok)
                        ok$message <- sum(iris[, ok$message])
                       }
                       ok <- jsonlite::toJSON(ok)
                       ws$send(ok)
                     })
                     ws$onClose(function() {
                       cat("Connection closed.\n")
                     })
                     
                   }
                 )
)

s$stop()
