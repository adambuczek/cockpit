<cockpit-finder>

    <style>

        .uk-offcanvas[name=editor] .CodeMirror {
            height: auto;
        }

    </style>

    <div show="{ data }">

        <div class="uk-clearfix" data-uk-margin>
            <div class="uk-float-left">


                <span class="uk-button uk-button-primary uk-margin-small-right uk-form-file">
                    <input class="js-upload-select" type="file" multiple="true" title="">
                    <i class="uk-icon-upload"></i>
                </span>

                <span class="uk-position-relative uk-margin-small-right" data-uk-dropdown="{\mode:'click'\}">

                    <span class="uk-button">
                        <i class="uk-icon-magic"></i>
                    </span>

                    <div class="uk-dropdown">
                        <ul class="uk-nav uk-nav-dropdown">
                            <li class="uk-nav-header">Create</li>
                            <li><a onclick="{ createfolder }"><i class="uk-icon-folder-o uk-icon-justify"></i> Folder</a></li>
                            <li><a onclick="{ createfile }"><i class="uk-icon-file-o uk-icon-justify"></i> File</a></li>
                        </ul>
                    </div>

                </span>

                <button class="uk-button uk-margin-small-right" onclick="{ refresh }">
                    <i class="uk-icon-refresh"></i>
                </button>

                <span if="{ selected.count }" data-uk-dropdown="\{mode:'click'\}">
                    <span class="uk-button"><strong>Batch:</strong> { selected.count } selected &nbsp;<i class="uk-icon-caret-down"></i></span>
                    <div class="uk-dropdown">
                        <ul class="uk-nav uk-nav-dropdown">
                            <li class="uk-nav-header">Batch action</li>
                            <li><a onclick="{ removeSelected }">Delete</a></li>
                        </ul>
                    </div>
                </span>
            </div>

            <div class="uk-float-right">

                <div class="uk-form uk-form-icon uk-width-1-1">
                    <i class="uk-icon-filter"></i>
                    <input name="filter" type="text" onkeyup="{ updatefilter }">
                </div>

            </div>
        </div>

        <div class="uk-grid uk-grid-divider uk-margin-large-top" data-uk-grid-margin>

            <div class="uk-width-medium-1-4">

                <div class="uk-panel">

                    <ul class="uk-nav uk-nav-side">
                        <li class="uk-nav-header">Display</li>
                        <li class="{ !typefilter ? 'uk-active':'' }"><a data-type="" onclick="{ settypefilter }"><i class="uk-icon-circle-o uk-icon-justify"></i> All</a></li>
                        <li class="{ typefilter=='images' ? 'uk-active':'' }"><a data-type="images" onclick="{ settypefilter }"><i class="uk-icon-image uk-icon-justify"></i> Images</a></li>
                        <li class="{ typefilter=='video' ? 'uk-active':'' }"><a data-type="video" onclick="{ settypefilter }"><i class="uk-icon-video-camera uk-icon-justify"></i> Video</a></li>
                        <li class="{ typefilter=='audio' ? 'uk-active':'' }"><a data-type="audio" onclick="{ settypefilter }"><i class="uk-icon-volume-up uk-icon-justify"></i> Audio</a></li>
                        <li class="{ typefilter=='documents' ? 'uk-active':'' }"><a data-type="documents" onclick="{ settypefilter }"><i class="uk-icon-paper-plane uk-icon-justify"></i> Documents</a></li>
                        <li class="{ typefilter=='archive' ? 'uk-active':'' }"><a data-type="archive" onclick="{ settypefilter }"><i class="uk-icon-archive uk-icon-justify"></i> Archive</a></li>
                    </ul>
                </div>

            </div>

            <div class="uk-width-medium-3-4">

                <div class="uk-panel">
                    <ul class="uk-breadcrumb">
                        <li onclick="{ changedir }"><a title="Change dir to root"><i class="uk-icon-home"></i></a></li>
                        <li each="{folder, idx in breadcrumbs}"><a onclick="{ parent.changedir }" title="Change dir to @@ folder.name @@">{ folder.name }</a></li>
                    </ul>
                </div>

                <div name="uploadprogress" class="uk-margin uk-hidden">
                    <div class="uk-progress">
                        <div name="progressbar" class="uk-progress-bar" style="width: 0%;">&nbsp;</div>
                    </div>
                </div>

                <div class="uk-alert uk-text-center uk-margin" if="{ (this.typefilter || this.filter.value) && (data.folders.length || data.files.length) }">
                     Filter is active
                </div>

                <div class="uk-alert uk-text-center uk-margin" if="{ (!data.folders.length && !data.files.length) }">
                    This is an empty folder
                </div>

                <div>

                    <div class="uk-margin-top" if="{data.folders.length}">

                        <strong class="uk-text-small uk-text-muted" if="{ !(this.filter.value) }"><i class="uk-icon-folder-o uk-margin-small-right"></i> { data.folders.length } Folders</strong>

                        <ul class="uk-grid uk-grid-small uk-grid-match uk-grid-width-1-2 uk-grid-width-medium-1-4">

                            <li class="uk-grid-margin" each="{folder, idx in data.folders}" onclick="{ parent.select }" if="{ parent.infilter(folder) }">
                                <div class="uk-panel uk-panel-box { folder.selected ? 'uk-selected':'' }">
                                    <div class="uk-flex">
                                        <div>
                                            <span class="uk-margin-small-right" data-uk-dropdown="\{mode:'click'\}">
                                                <i class="uk-icon-folder-o uk-text-muted js-no-item-select"></i>
                                                <div class="uk-dropdown">
                                                    <ul class="uk-nav uk-nav-dropdown">
                                                        <li class="uk-nav-header uk-text-truncate">{ folder.name }</li>
                                                        <li><a onclick="{ parent.rename }">Rename</a></li>
                                                        <li><a onclick="{ parent.remove }">Delete</a></li>
                                                    </ul>
                                                </div>
                                            </span>
                                        </div>
                                        <div class="uk-flex-item-1 uk-text-truncate">
                                            <a class="uk-link-muted" onclick="{ parent.changedir }"><strong>{ folder.name }</strong></a>
                                        </div>
                                    </div>
                                </div>
                            </li>

                        </ul>

                    </div>

                    <div class="uk-margin-top" if="{data.files.length}">

                        <strong class="uk-text-small uk-text-muted" if="{ !(this.typefilter || this.filter.value) }"><i class="uk-icon-file-o uk-margin-small-right"></i> { data.files.length } Files</strong>

                        <ul class="uk-grid uk-grid-small uk-grid-match uk-grid-width-1-2 uk-grid-width-medium-1-4">

                            <li class="uk-grid-margin" each="{file, idx in data.files}" onclick="{ parent.select }" if="{ parent.infilter(file) }">
                                <div class="uk-panel uk-panel-box { file.selected ? 'uk-selected':'' }">
                                    <div class="uk-flex">
                                        <div>
                                            <span class="uk-margin-small-right" data-uk-dropdown="\{mode:'click'\}">
                                                <i class="uk-icon-{ parent.getIconCls(file) } uk-text-muted js-no-item-select"></i>
                                                <div class="uk-dropdown">
                                                    <ul class="uk-nav uk-nav-dropdown">
                                                        <li class="uk-nav-header uk-text-truncate">{ file.name }</li>
                                                        <li><a onclick="{ parent.rename }">Rename</a></li>
                                                        <li if="{ file.ext == 'zip' }"><a onclick="{ parent.unzip }">Unzip</a></li>
                                                        <li class="uk-nav-divider"></li>
                                                        <li><a onclick="{ parent.remove }">Delete</a></li>
                                                    </ul>
                                                </div>
                                            </span>
                                        </div>
                                        <div class="uk-flex-item-1 uk-text-truncate">

                                            <a class="uk-link-muted js-no-item-select" onclick="{ parent.open }">{ file.name }</a>

                                            <div class="uk-margin-small-top uk-text-small uk-text-muted">
                                                { file.size }
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </li>
                        </ul>

                    </div>
                </div>

            </div>

        </div>

        <div name="editor" class="uk-offcanvas">
            <div class="uk-offcanvas-bar uk-width-3-4">
                <picoedit></picoedit>
            </div>
        </div>

    </div>


    <script>

        var $this = this,
            typefilters = {
                'images'    : /\.(jpg|jpeg|png|gif|svg)$/i,
                'video'     : /\.(mp4|mov|ogv|webv|flv|avi)$/i,
                'audio'     : /\.(mp3|weba|ogg|wav|flac)$/i,
                'archive'   : /\.(zip|rar|7zip|gz)$/i,
                'documents' : /\.(htm|html|pdf)$/i,
                'text'      : /\.(txt|htm|html|php|css|less|js|json|md|markdown|yaml|xml)$/i
            };

        this.currentpath = '/';

        this.data;
        this.breadcrumbs = [];
        this.selected    = {count:0, paths:{}};
        this.bookmarks   = {"folders":[], "files":[]};

        this.viewfilter = 'all';
        this.namefilter = '';

        this.mode       = 'table';
        this.dirlist    = false;
        this.selected   = {};


        App.$(this.editor).on('click', function(e){

            if (e.target.classList.contains('uk-offcanvas-bar')) {
                $this.tags.picoedit.codemirror.editor.focus();
            }
        });

        this.on('mount', function(){

            this.loadPath()

            // handle uploads
            App.assets.require(['/assets/lib/uikit/js/components/upload.js'], function() {

                var uploadSettings = {

                        action: App.route('/media/api'),
                        params: {"cmd":"upload"},
                        type: 'json',
                        before: function(options) {
                            options.params.path = $this.currentpath;
                        },
                        loadstart: function() {
                            $this.uploadprogress.classList.remove('uk-hidden');
                        },
                        progress: function(percent) {

                            percent = Math.ceil(percent) + '%';

                            $this.progressbar.innerHTML   = '<span>'+percent+'</span>';
                            $this.progressbar.style.width = percent;
                        },
                        allcomplete: function(response) {

                            $this.uploadprogress.classList.add('uk-hidden');

                            if (response && response.failed && response.failed.length) {
                                App.ui.notify("File(s) failed to uploaded.", "danger");
                            }

                            if (response && response.uploaded && response.uploaded.length) {
                                App.ui.notify("File(s) uploaded.", "success");
                                $this.loadPath();
                            }

                            if (!response) {
                                App.ui.notify("Soething went wrong.", "danger");
                            }

                        }
                },

                uploadselect = UIkit.uploadSelect(App.$('.js-upload-select', $this.root)[0], uploadSettings),
                uploaddrop   = UIkit.uploadDrop($this.root, uploadSettings);

                UIkit.init(this.root);
            });
        });


        changedir(e, path) {

            if (e && e.item) {
                e.stopPropagation();
                path = e.item.folder.path;
            } else {
                path = '/';
            }

            this.loadPath(path);
        }

        open(evt) {

            if (opts.previewfiles === false) {
                this.select(evt, true);
                return;
            }

            var file = evt.item.file,
                name = file.name.toLowerCase();

            if (name.match(typefilters.images)) {

                UIkit.lightbox.create([
                    {'source': file.url, 'type':'image'}
                ]).show();

            } else if(name.match(typefilters.video)) {

                UIkit.lightbox.create([
                    {'source': file.url, 'type':'video'}
                ]).show();

            } else if(name.match(typefilters.text)) {

                UIkit.offcanvas.show(this.editor);
                this.tags.picoedit.open(file.path);

            } else {
                App.ui.notify("Filetype nor supported");
            }
        }

        refresh() {
            this.loadPath().then(function(){
                App.ui.notify('Folder reloaded');
            });
        }

        select(e, force) {

            if (e && e.item && force || !e.target.classList.contains('js-no-item-select') && !App.$(e.target).parents('.js-no-item-select').length) {

                // remove any text selection
                try {
                    window.getSelection().empty()
                } catch(err) {
                    try {
                        window.getSelection().removeAllRanges()
                    } catch(err){}
                }

                var item = e.item.folder || e.item.file, idx = e.item.idx;

                if (e.shiftKey) {

                    var prev, items = this.data[item.is_file ? 'files' : 'folders'];

                    for (var i=idx;i>=0;i--) {
                        if (items[i].selected) break;

                        items[i].selected = true;
                        this.selected.paths[items[i].path] = items[i];
                    }

                    this.selected.count = Object.keys(this.selected.paths).length;

                    return;
                }

                if (!(e.metaKey || e.ctrlKey)) {

                    Object.keys(this.selected.paths).forEach(function(path) {
                        if (path != item.path) {
                            $this.selected.paths[path].selected = false;
                            delete $this.selected.paths[path];
                        }
                    });
                }

                item.selected = !item.selected;

                if (!item.selected && this.selected.paths[item.path]) {
                    delete this.selected.paths[item.path];
                }

                if (item.selected && !this.selected.paths[item.path]) {
                    this.selected.paths[item.path] = item;
                }

                this.selected.count = Object.keys(this.selected.paths).length;

                if (opts.onChangeSelect) {
                    opts.onChangeSelect(this.selected);
                }
            }
        }

        rename(e, item) {

            e.stopPropagation();

            item = e.item.folder || e.item.file;

            App.ui.prompt("Please enter a name:", item.name, function(name){


                if (name!=item.name && name.trim()) {

                    requestapi({"cmd":"rename", "path": item.path, "name":name});
                    item.path = item.path.replace(item.name, name);
                    item.name = name;

                    $this.update();
                }

            });
        }

        unzip(e, item) {

            e.stopPropagation();

            item = e.item.file;

            requestapi({"cmd": "unzip", "path": $this.currentpath, "zip": item.path}, function(resp){

                if (resp) {

                    if (resp.success) {
                        App.ui.notify("Archive extracted!", "success");
                    } else {
                        App.ui.notify("Extracting archive failed!", "error");
                    }
                }

                $this.loadPath();

            });
        }

        remove(e, item, index) {

            e.stopPropagation();

            item = e.item.folder || e.item.file;

            App.ui.confirm("Are you sure?", function() {

                requestapi({"cmd":"removefiles", "paths": item.path}, function(){

                    index = $this.data[item.is_file ? "files":"folders"].indexOf(item);

                    $this.data[item.is_file ? "files":"folders"].splice(index, 1);

                    App.ui.notify("Item(s) deleted", "success");

                    $this.update();
                });
            });
        }

        removeSelected() {

            var paths = Object.keys(this.selected.paths);

            if (paths.length) {

                App.ui.confirm("Are you sure?", function() {

                    requestapi({"cmd":"removefiles", "paths": paths}, function(){
                        $this.loadPath();
                        App.ui.notify("File(s) deleted", "success");
                    });
                });
            }
        }

        createfolder() {

            App.ui.prompt("Please enter a folder name:", "", function(name){

                if (name.trim()) {
                    requestapi({"cmd":"createfolder", "path": $this.currentpath, "name":name}, function(){
                        $this.loadPath();
                    });
                }
            });
        }

        createfile() {

            App.ui.prompt("Please enter a file name:", "", function(name){

                if (name.trim()) {
                    requestapi({"cmd":"createfile", "path": $this.currentpath, "name":name}, function(){
                        $this.loadPath();
                    });
                }
            });
        }

        loadPath(path, defer) {

            path  = path || $this.currentpath;
            defer = App.deferred();

            requestapi({"cmd":"ls", "path": path}, function(data){

                $this.currentpath = path;
                $this.breadcrumbs = [];
                $this.selected    = {};
                $this.selectAll   = false;

                if ($this.currentpath && $this.currentpath != '/' && $this.currentpath != '.'){
                    var parts   = $this.currentpath.split('/'),
                        tmppath = [],
                        crumbs  = [];

                    for(var i=0;i<parts.length;i++){
                        tmppath.push(parts[i]);
                        crumbs.push({'name':parts[i],'path':tmppath.join("/")});
                    }

                    $this.breadcrumbs = crumbs;
                }

                defer.resolve(data);

                $this.data = data;

                $this.resetselected();
                $this.update();

            });

            return defer;
        }

        settypefilter(evt) {
            this.typefilter = evt.target.dataset.type;
            this.resetselected();
        }

        updatefilter(evt) {
            this.resetselected();
        }

        infilter(item) {

            var name = item.name.toLowerCase();

            if (this.typefilter && item.is_file && typefilters[this.typefilter]) {

                if (!name.match(typefilters[this.typefilter])) {
                    return false;
                }
            }

            return (!this.filter.value || (name && name.indexOf(this.filter.value.toLowerCase()) !== -1));
        }

        resetselected() {

            if (this.selected.paths) {
                Object.keys(this.selected.paths).forEach(function(path) {
                    $this.selected.paths[path].selected = false;
                });
            }

            this.selected  = {count:0, paths:{}};

            if (opts.onChangeSelect) {
                opts.onChangeSelect(this.selected);
            }
        }

        getIconCls(file) {

            var name = file.name.toLowerCase();

            if (name.match(typefilters.images)) {

                return 'image';

            } else if(name.match(typefilters.video)) {

                return 'video';

            } else if(name.match(typefilters.text)) {

                return 'pencil';

            } else if(name.match(typefilters.archive)) {

                return 'archive';

            } else {
                return 'file-o';
            }
        }


        function requestapi(data, fn, type) {

            data = Object.assign({"cmd":""}, data);

            App.request('/media/api', data).then(fn);
        }


    </script>

</cockpit-finder>
