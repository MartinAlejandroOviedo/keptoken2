--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (PGlite 0.2.0)
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET row_security = off;

--
-- Name: meta; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA meta;


ALTER SCHEMA meta OWNER TO postgres;

--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: embeddings; Type: TABLE; Schema: meta; Owner: postgres
--

CREATE TABLE meta.embeddings (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    content text NOT NULL,
    embedding public.vector(384) NOT NULL
);


ALTER TABLE meta.embeddings OWNER TO postgres;

--
-- Name: embeddings_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

ALTER TABLE meta.embeddings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME meta.embeddings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: migrations; Type: TABLE; Schema: meta; Owner: postgres
--

CREATE TABLE meta.migrations (
    version text NOT NULL,
    name text,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE meta.migrations OWNER TO postgres;

--
-- Name: beneficios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beneficios (
    id_beneficio bigint NOT NULL,
    titulo text,
    descripcion text,
    icono text,
    orden integer,
    activo boolean
);


ALTER TABLE public.beneficios OWNER TO postgres;

--
-- Name: beneficios_id_beneficio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.beneficios ALTER COLUMN id_beneficio ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.beneficios_id_beneficio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bloques; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bloques (
    id_bloque bigint NOT NULL,
    tipo_bloque text,
    contenido text,
    orden integer,
    activo boolean
);


ALTER TABLE public.bloques OWNER TO postgres;

--
-- Name: bloques_id_bloque_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.bloques ALTER COLUMN id_bloque ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bloques_id_bloque_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: capacidades_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capacidades_roles (
    id_rol bigint NOT NULL,
    id_permiso bigint NOT NULL
);


ALTER TABLE public.capacidades_roles OWNER TO postgres;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id_categoria bigint NOT NULL,
    nombre_categoria text,
    imagen text
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: categorias_eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias_eventos (
    id_categoria bigint NOT NULL,
    nombre_categoria text
);


ALTER TABLE public.categorias_eventos OWNER TO postgres;

--
-- Name: categorias_eventos_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categorias_eventos ALTER COLUMN id_categoria ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categorias_eventos_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categorias ALTER COLUMN id_categoria ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categorias_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: comentarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comentarios (
    id_comentario bigint NOT NULL,
    contexto text,
    id_elemento bigint,
    id_usuario bigint,
    comentario text,
    fecha_publicacion timestamp without time zone,
    activo boolean
);


ALTER TABLE public.comentarios OWNER TO postgres;

--
-- Name: comentarios_eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comentarios_eventos (
    id_comentario bigint NOT NULL,
    id_evento bigint,
    id_usuario bigint,
    comentario text,
    fecha_publicacion timestamp without time zone,
    activo boolean
);


ALTER TABLE public.comentarios_eventos OWNER TO postgres;

--
-- Name: comentarios_eventos_id_comentario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.comentarios_eventos ALTER COLUMN id_comentario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.comentarios_eventos_id_comentario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: comentarios_id_comentario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.comentarios ALTER COLUMN id_comentario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.comentarios_id_comentario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: etiquetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etiquetas (
    id_etiqueta bigint NOT NULL,
    nombre_etiqueta text
);


ALTER TABLE public.etiquetas OWNER TO postgres;

--
-- Name: etiquetas_id_etiqueta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.etiquetas ALTER COLUMN id_etiqueta ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.etiquetas_id_etiqueta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventos (
    id_evento bigint NOT NULL,
    titulo text,
    descripcion text,
    fecha_evento timestamp without time zone,
    ubicacion text,
    id_autor bigint,
    id_categoria bigint
);


ALTER TABLE public.eventos OWNER TO postgres;

--
-- Name: eventos_id_evento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.eventos ALTER COLUMN id_evento ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.eventos_id_evento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hero_slider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hero_slider (
    id_slider bigint NOT NULL,
    imagen text,
    titulo text,
    descripcion text,
    boton_texto text,
    boton_url text,
    orden integer,
    activo boolean
);


ALTER TABLE public.hero_slider OWNER TO postgres;

--
-- Name: hero_slider_id_slider_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.hero_slider ALTER COLUMN id_slider ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hero_slider_id_slider_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: imagenes_eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagenes_eventos (
    id_imagen bigint NOT NULL,
    id_evento bigint,
    url_imagen text
);


ALTER TABLE public.imagenes_eventos OWNER TO postgres;

--
-- Name: imagenes_eventos_id_imagen_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.imagenes_eventos ALTER COLUMN id_imagen ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imagenes_eventos_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: imagenes_post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagenes_post (
    id_imagen bigint NOT NULL,
    id_post bigint,
    url_imagen text
);


ALTER TABLE public.imagenes_post OWNER TO postgres;

--
-- Name: imagenes_post_id_imagen_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.imagenes_post ALTER COLUMN id_imagen ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imagenes_post_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: imagenes_usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagenes_usuarios (
    id_imagen bigint NOT NULL,
    id_usuario bigint,
    url_imagen text
);


ALTER TABLE public.imagenes_usuarios OWNER TO postgres;

--
-- Name: imagenes_usuarios_id_imagen_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.imagenes_usuarios ALTER COLUMN id_imagen ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imagenes_usuarios_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: informacion_empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.informacion_empresa (
    id_info bigint NOT NULL,
    nombre_empresa text,
    descripcion text,
    meta_keywords text,
    correo_contacto text,
    telefono text,
    direccion text,
    redes_sociales json,
    logo text,
    favicon text,
    titulo_pagina text,
    meta_social json
);


ALTER TABLE public.informacion_empresa OWNER TO postgres;

--
-- Name: informacion_empresa_id_info_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.informacion_empresa ALTER COLUMN id_info ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.informacion_empresa_id_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu (
    id_menu bigint NOT NULL,
    titulo text,
    url text,
    orden integer,
    activo boolean
);


ALTER TABLE public.menu OWNER TO postgres;

--
-- Name: menu_id_menu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.menu ALTER COLUMN id_menu ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.menu_id_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permisos (
    id_permiso bigint NOT NULL,
    nombre_permiso text
);


ALTER TABLE public.permisos OWNER TO postgres;

--
-- Name: permisos_id_permiso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.permisos ALTER COLUMN id_permiso ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.permisos_id_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: post_etiquetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_etiquetas (
    id_post bigint NOT NULL,
    id_etiqueta bigint NOT NULL
);


ALTER TABLE public.post_etiquetas OWNER TO postgres;

--
-- Name: post_noticias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_noticias (
    id_post bigint NOT NULL,
    titulo text,
    contenido text,
    imagen text,
    fecha_publicacion timestamp without time zone,
    id_autor bigint,
    id_categoria bigint,
    fecha_modificacion timestamp without time zone
);


ALTER TABLE public.post_noticias OWNER TO postgres;

--
-- Name: post_noticias_id_post_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.post_noticias ALTER COLUMN id_post ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.post_noticias_id_post_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_rol bigint NOT NULL,
    nombre_rol text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id_rol ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: servicios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicios (
    id_servicio bigint NOT NULL,
    titulo text,
    descripcion text,
    icono text,
    orden integer,
    activo boolean
);


ALTER TABLE public.servicios OWNER TO postgres;

--
-- Name: servicios_id_servicio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.servicios ALTER COLUMN id_servicio ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.servicios_id_servicio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testimonials (
    id_testimonial bigint NOT NULL,
    nombre text,
    testimonio text,
    imagen text,
    orden integer,
    activo boolean
);


ALTER TABLE public.testimonials OWNER TO postgres;

--
-- Name: testimonials_id_testimonial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.testimonials ALTER COLUMN id_testimonial ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.testimonials_id_testimonial_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario bigint NOT NULL,
    nombre text,
    apellido text,
    correo_electronico text,
    contrasena text,
    salt text,
    id_rol bigint,
    redes_sociales json,
    telefono text,
    alias text
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuarios ALTER COLUMN id_usuario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: embeddings; Type: TABLE DATA; Schema: meta; Owner: postgres
--



--
-- Data for Name: migrations; Type: TABLE DATA; Schema: meta; Owner: postgres
--

INSERT INTO meta.migrations VALUES ('202407160001', 'embeddings', '2025-04-02 01:01:55.755+00');


--
-- Data for Name: beneficios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: bloques; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: capacidades_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: categorias_eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: comentarios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: comentarios_eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: etiquetas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: hero_slider; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: imagenes_eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: imagenes_post; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: imagenes_usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: informacion_empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: post_etiquetas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: post_noticias; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: servicios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: testimonials; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: embeddings_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('meta.embeddings_id_seq', 1, false);


--
-- Name: beneficios_id_beneficio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.beneficios_id_beneficio_seq', 1, false);


--
-- Name: bloques_id_bloque_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bloques_id_bloque_seq', 1, false);


--
-- Name: categorias_eventos_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_eventos_id_categoria_seq', 1, false);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 1, false);


--
-- Name: comentarios_eventos_id_comentario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comentarios_eventos_id_comentario_seq', 1, false);


--
-- Name: comentarios_id_comentario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comentarios_id_comentario_seq', 1, false);


--
-- Name: etiquetas_id_etiqueta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etiquetas_id_etiqueta_seq', 1, false);


--
-- Name: eventos_id_evento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eventos_id_evento_seq', 1, false);


--
-- Name: hero_slider_id_slider_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hero_slider_id_slider_seq', 1, false);


--
-- Name: imagenes_eventos_id_imagen_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imagenes_eventos_id_imagen_seq', 1, false);


--
-- Name: imagenes_post_id_imagen_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imagenes_post_id_imagen_seq', 1, false);


--
-- Name: imagenes_usuarios_id_imagen_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imagenes_usuarios_id_imagen_seq', 1, false);


--
-- Name: informacion_empresa_id_info_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.informacion_empresa_id_info_seq', 1, false);


--
-- Name: menu_id_menu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_id_menu_seq', 1, false);


--
-- Name: permisos_id_permiso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permisos_id_permiso_seq', 1, false);


--
-- Name: post_noticias_id_post_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_noticias_id_post_seq', 1, false);


--
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_rol_seq', 1, false);


--
-- Name: servicios_id_servicio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicios_id_servicio_seq', 1, false);


--
-- Name: testimonials_id_testimonial_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.testimonials_id_testimonial_seq', 1, false);


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 1, false);


--
-- Name: embeddings embeddings_pkey; Type: CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY meta.embeddings
    ADD CONSTRAINT embeddings_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY meta.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: beneficios beneficios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficios
    ADD CONSTRAINT beneficios_pkey PRIMARY KEY (id_beneficio);


--
-- Name: bloques bloques_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bloques
    ADD CONSTRAINT bloques_pkey PRIMARY KEY (id_bloque);


--
-- Name: capacidades_roles capacidades_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capacidades_roles
    ADD CONSTRAINT capacidades_roles_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- Name: categorias_eventos categorias_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias_eventos
    ADD CONSTRAINT categorias_eventos_pkey PRIMARY KEY (id_categoria);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- Name: comentarios_eventos comentarios_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios_eventos
    ADD CONSTRAINT comentarios_eventos_pkey PRIMARY KEY (id_comentario);


--
-- Name: comentarios comentarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id_comentario);


--
-- Name: etiquetas etiquetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etiquetas
    ADD CONSTRAINT etiquetas_pkey PRIMARY KEY (id_etiqueta);


--
-- Name: eventos eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_pkey PRIMARY KEY (id_evento);


--
-- Name: hero_slider hero_slider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hero_slider
    ADD CONSTRAINT hero_slider_pkey PRIMARY KEY (id_slider);


--
-- Name: imagenes_eventos imagenes_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes_eventos
    ADD CONSTRAINT imagenes_eventos_pkey PRIMARY KEY (id_imagen);


--
-- Name: imagenes_post imagenes_post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes_post
    ADD CONSTRAINT imagenes_post_pkey PRIMARY KEY (id_imagen);


--
-- Name: imagenes_usuarios imagenes_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes_usuarios
    ADD CONSTRAINT imagenes_usuarios_pkey PRIMARY KEY (id_imagen);


--
-- Name: informacion_empresa informacion_empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacion_empresa
    ADD CONSTRAINT informacion_empresa_pkey PRIMARY KEY (id_info);


--
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id_menu);


--
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_permiso);


--
-- Name: post_etiquetas post_etiquetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_etiquetas
    ADD CONSTRAINT post_etiquetas_pkey PRIMARY KEY (id_post, id_etiqueta);


--
-- Name: post_noticias post_noticias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_noticias
    ADD CONSTRAINT post_noticias_pkey PRIMARY KEY (id_post);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- Name: servicios servicios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicios
    ADD CONSTRAINT servicios_pkey PRIMARY KEY (id_servicio);


--
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id_testimonial);


--
-- Name: usuarios usuarios_correo_electronico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_electronico_key UNIQUE (correo_electronico);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: capacidades_roles capacidades_roles_id_permiso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capacidades_roles
    ADD CONSTRAINT capacidades_roles_id_permiso_fkey FOREIGN KEY (id_permiso) REFERENCES public.permisos(id_permiso);


--
-- Name: capacidades_roles capacidades_roles_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capacidades_roles
    ADD CONSTRAINT capacidades_roles_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- Name: comentarios_eventos comentarios_eventos_id_evento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios_eventos
    ADD CONSTRAINT comentarios_eventos_id_evento_fkey FOREIGN KEY (id_evento) REFERENCES public.eventos(id_evento);


--
-- Name: comentarios_eventos comentarios_eventos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios_eventos
    ADD CONSTRAINT comentarios_eventos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: comentarios comentarios_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT comentarios_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: eventos eventos_id_autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_id_autor_fkey FOREIGN KEY (id_autor) REFERENCES public.usuarios(id_usuario);


--
-- Name: eventos eventos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias_eventos(id_categoria);


--
-- Name: imagenes_eventos imagenes_eventos_id_evento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes_eventos
    ADD CONSTRAINT imagenes_eventos_id_evento_fkey FOREIGN KEY (id_evento) REFERENCES public.eventos(id_evento);


--
-- Name: imagenes_post imagenes_post_id_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes_post
    ADD CONSTRAINT imagenes_post_id_post_fkey FOREIGN KEY (id_post) REFERENCES public.post_noticias(id_post);


--
-- Name: imagenes_usuarios imagenes_usuarios_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes_usuarios
    ADD CONSTRAINT imagenes_usuarios_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: post_etiquetas post_etiquetas_id_etiqueta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_etiquetas
    ADD CONSTRAINT post_etiquetas_id_etiqueta_fkey FOREIGN KEY (id_etiqueta) REFERENCES public.etiquetas(id_etiqueta);


--
-- Name: post_etiquetas post_etiquetas_id_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_etiquetas
    ADD CONSTRAINT post_etiquetas_id_post_fkey FOREIGN KEY (id_post) REFERENCES public.post_noticias(id_post);


--
-- Name: post_noticias post_noticias_id_autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_noticias
    ADD CONSTRAINT post_noticias_id_autor_fkey FOREIGN KEY (id_autor) REFERENCES public.usuarios(id_usuario);


--
-- Name: post_noticias post_noticias_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_noticias
    ADD CONSTRAINT post_noticias_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria);


--
-- Name: usuarios usuarios_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- PostgreSQL database dump complete
--

