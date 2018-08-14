library(httr)
library(jsonlite)

congressmen_edges = data.frame("", "", "")
names(congressmen_edges) = c("name", "project", "posicion")

congressmen_nodes = data.frame("", "")
names(congressmen_nodes) = c("name", "gender")

next_page = "https://www.congresovisible.org/api/apis/candidatos/"

repeat {
  index = 0
  json_content = fromJSON(next_page)
  for(projects in json_content$results$project_votes) {
    index = index + 1
    if (class(projects) == "data.frame" && dim(projects)[1] != 0) {
      name = as.character(paste(json_content$results$last_name[index], json_content$results$first_name[index], sep = " ", collapse = NULL))
      
      congressman = data.frame(name, projects)
      names(congressman) = c("name", "posicion", "project")
      congressmen_edges = rbind(congressmen_edges, congressman)
      
      congressman = data.frame(name, json_content$results$gender[index])
      names(congressman) = c("name", "gender")
      congressmen_nodes = rbind(congressmen_nodes, congressman)
    }
  }
  next_page = json_content$"next"
  print(next_page)
  if(is.null(next_page)) {
    congressmen_nodes = congressmen_nodes[-c(1), ]
    write.csv2(congressmen_nodes, file = "congressmen_nodes.csv", 
               row.names = FALSE, fileEncoding = "utf-8")
    
    congressmen_edges = congressmen_edges[-c(1), ]
    write.csv2(congressmen_edges, file = "congressmen_edges.csv", 
               row.names = FALSE, fileEncoding = "utf-8")
    break
  }
}


