CREATE TABLE projects (
    id SERIAL NOT NULL UNIQUE,
    name varchar(255),
    description varchar(255),

    user_email varchar(255) NOT NULL,
    group_name varchar(255) NOT NULL,
    permissions smallint NOT NULL
);

CREATE TABLE git_remotes (
    url varchar(255) NOT NULL,
    branch varchar(255) NOT NULL,

    project_id INTEGER NOT NULL,

    FOREIGN KEY (project_id) REFERENCES projects(id),
    PRIMARY KEY(url, branch),
    UNIQUE(url, branch)
);

CREATE TABLE pipelines (
    id SERIAL NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    success boolean,

    remote_url varchar(255) NOT NULL,
    remote_branch varchar(255) NOT NULL,
    project_id INTEGER NOT NULL,

    FOREIGN KEY (remote_url, remote_branch) REFERENCES git_remotes(url, branch),
    FOREIGN KEY (project_id) REFERENCES projects(id),
    PRIMARY KEY(id)
);

CREATE TABLE runs (
    /* The count is scoped to the pipeline. It's not an overall count. */
    count INTEGER NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp,
    success boolean,

    pipeline_id INTEGER NOT NULL,

    FOREIGN KEY (pipeline_id) REFERENCES pipelines(id),
    PRIMARY KEY (pipeline_id, count)
);

CREATE TABLE steps (
    id SERIAL NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp,
    success boolean,

    /* Pipelines can change over time. For this reason, stored steps must
    belong to the pipeline run and not necessarily the overall pipeline. */
    pipeline_id INTEGER NOT NULL,
    run_count INTEGER NOT NULL,

    FOREIGN KEY (pipeline_id, run_count) REFERENCES runs(pipeline_id, count),
    PRIMARY KEY (id)
);

CREATE TABLE tasks (
    id SERIAL NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp,
    success boolean,

    step_id INTEGER NOT NULL,

    FOREIGN KEY (step_id) REFERENCES steps(id),
    PRIMARY KEY (id)
);

CREATE TABLE groups (
    name varchar(255) NOT NULL UNIQUE,

    PRIMARY KEY (name)
);

CREATE TABLE users (
    email varchar(255) NOT NULL UNIQUE,
    password varchar(255) NOT NULL UNIQUE,

    name varchar(255) NOT NULL,

    group_name varchar(255),

    FOREIGN KEY (group_name) REFERENCES groups(name),
    PRIMARY KEY (email)
);
