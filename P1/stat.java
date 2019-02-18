    public void stat(String element) {
        if(element.equals("/")) {
            Elemento raiz = path.getFirst();
            HashMap<String,Elemento> files = ((Directorio)raiz).getFiles();
            int tam = 0;
            for(Elemento e: files.values()) {
                tam += e.getTam();
            }
            System.out.println(tam);
            return ;
        }
        String[] ruta = element.split("/");
        LinkedList<Elemento> copyPath = new LinkedList<>();
        copyPath.addAll(path);
        if (ruta[0].isEmpty()) {
            Elemento raiz = copyPath.getFirst();
            copyPath.clear();
            copyPath.add(raiz);
        }
        for (int i = 0; i < ruta.length; i++) {
            String dest = ruta[i];
            if (dest.equals("..")) {
                if(!ruta[i+1].isEmpty()) {
                    copyPath.removeLast();
                }
                else{
                    copyPath.removeLast();
                    Elemento actual = copyPath.getLast();
                    if(actual != null && actual instanceof Directorio){
                        HashMap<String,Elemento> files = ((Directorio)actual).getFiles();
                        for(Elemento e: files.values()) {
                            System.out.println(e.getTam());
                        }
                        return ;
                    }
                }
            } else if (!dest.equals(".")) {
                Elemento actual = copyPath.getLast();
                if (actual != null && actual instanceof Directorio) {
                    if (ruta[i + 1].isEmpty()) {
                        HashMap<String,Elemento> files = ((Directorio) actual).getFiles();
                        if(files.containsKey(dest)){
                            Elemento e = files.get(dest);
                            if(e instanceof Archivo || e instanceof Directorio) {
                                System.out.println(files.get(dest).getTam());
                            }
                            else if(e instanceof Enlace){
                                Elemento padre = ((Enlace)e).getPadre();
                                System.out.println(padre.getTam());
                            }
                        }
                    } else {
                        HashMap<String, Elemento> elements = ((Directorio) actual).getFiles();
                        Elemento jump_to = elements.get(dest);
                        if (jump_to != null && jump_to instanceof Directorio) {
                            copyPath.add(jump_to);
                        } else if (jump_to != null && jump_to instanceof Enlace) {
                            Elemento pat = ((Enlace) jump_to).getPadre();
                            if (pat != null && pat instanceof Directorio) {
                                path.add(pat);
                            } else {
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                } else if (actual != null && actual instanceof Enlace) {
                    Elemento padre = ((Enlace) actual).getPadre();
                    if (padre != null && padre instanceof Archivo) {
                        System.out.println(padre.getTam());
                    } else if (padre != null && padre instanceof Directorio) {
                        if (ruta[i + 1].isEmpty()) {
                            HashMap<String,Elemento> files = ((Directorio) padre).getFiles();
                            if(files.containsKey(dest)){
                                System.out.println(actual.getTam());
                            }
                        } else {
                            HashMap<String, Elemento> elements = ((Directorio) padre).getFiles();
                            Elemento jump_to = elements.get(dest);
                            if (jump_to != null && jump_to instanceof Directorio) {
                                path.add(jump_to);
                            } else if (jump_to != null && jump_to instanceof Enlace) {
                                Elemento pat = ((Enlace) jump_to).getPadre();
                                if (pat != null && pat instanceof Directorio) {
                                    copyPath.add(pat);
                                } else {
                                    break;
                                }
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
