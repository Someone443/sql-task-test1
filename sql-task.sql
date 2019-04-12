CREATE TABLE "projects" (
	"id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
	PRIMARY KEY ("id")
);
CREATE TABLE "tasks" (
	"id" INTEGER NOT NULL,
	"name" TEXT NOT NULL,
    "status" VARCHAR(256) NULL,
    "project_id" INTEGER NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("project_id") REFERENCES projects("id")
);

-- 1. Get all statuses, not repeating, alphabetically ordered 
SELECT DISTINCT public.tasks.status FROM public.tasks ORDER BY public.tasks.status ASC;

-- 2. Get the count of all tasks in each project, order by tasks count descending
SELECT p.name project_name, count(t.*) tasks_count FROM public.projects p 
LEFT JOIN public.tasks t ON t.project_id = p.id GROUP BY p.id ORDER BY tasks_count DESC; 

-- 3. Get the count of all tasks in each project, order by projects names
SELECT p.name project_name, count(t.*) tasks_count FROM public.projects p 
LEFT JOIN public.tasks t ON t.project_id = p.id GROUP BY p.id ORDER BY project_name ASC; 

-- 4. Get the tasks for all projects having the name beginning with "N" letter
SELECT * FROM public.tasks WHERE public.tasks.name LIKE 'N%';

-- 5. Get the list of all projects containing the "a" letter in the middle of the name, and show the tasks count 
-- near each project. Mention that there can exist projects without tasks and tasks with project_id = NULL
SELECT p.*, count(t.*) tasks_count FROM public.projects p 
LEFT JOIN public.tasks t ON t.project_id = p.id WHERE p.name LIKE '%a%' GROUP BY p.id;

-- 6. Get the list of tasks with duplicate names. Order alphabetically
SELECT t.name FROM public.tasks t GROUP BY t.name HAVING COUNT(*) > 1 ORDER BY t.name ASC;

-- 7. Get the list of tasks having several exact matches of both name and status, from the project 'Garage'. Order by matches count
SELECT t.name, t.status FROM public.tasks t 
LEFT JOIN public.projects p ON p.id = t.project_id WHERE p.name = 'Garage' 
GROUP BY t.name, t.status HAVING COUNT(*) > 1 ORDER BY COUNT(*);

-- 8. Get the list of project names having more than 10 tasks in status 'completed'. Order by project_id
SELECT p.name project_name, p.id project_id, COUNT(t.*) completed_count FROM public.tasks t 
LEFT JOIN public.projects p ON p.id = t.project_id WHERE t.status = 'completed' 
GROUP BY p.id HAVING COUNT(t.status = 'completed') > 10 ORDER BY p.id;